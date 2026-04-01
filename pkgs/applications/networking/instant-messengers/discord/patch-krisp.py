#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p "python3.withPackages (ps: [ ps.lief ps.capstone ])"
"""
Patch discord_krisp.node to bypass its signature verification

Krisp checks its own code signature on load. Since Nix modifies the binary (e.g.
patchelf), the signature no longer matches and the module refuses to start. We
patch the verification function to always return true

ELF (Linux)
-----------
The check lives in discord::util::IsSignedByDiscord(). It MD5-hashes the file
and compares the result with SSE2. Discord ships stripped ELFs, but .eh_frame
(DWARF unwind info) still gives us every function's start address. We scan .text
for the unique MD5-compare byte sequence (pmovmskb + cmp $0xffff), find the
function whose range contains it, and overwrite the entry with "mov eax, 1; ret"

  # before:                                    # after:
  #   pmovmskb %xmm0, %eax  ; 66 0f d7 c0      #   mov $0x1, %eax  ; b8 01 00 00 00
  #   cmp $0xffff, %eax     ; 3d ff ff 00 00   #   ret             ; c3
  #   sete %bpl             ; 40 0f 94 c5      #

Mach-O (macOS, fat binary: x86_64 + arm64)
------------------------------------------
On macOS the check uses Apple's Security framework. We anchor on the
_SecStaticCodeCreateWithPath import stub, disassemble __text once with capstone,
and build a ``branch target -> containing function`` index. We hop up through
unique callers until the chain fans out (0 or 2+ callers)

  # the call chain (from nm + c++filt, addresses vary per build):
  #   _SecStaticCodeCreateWithPath   [stub]
  #     <- GetSigningInformation()   hop 1 (only caller of the stub)
  #       <- IsSignedBy()            hop 2 (only caller of hop 1)
  #         <- IsSignedByDiscord()   hop 3 (only caller of hop 2) <- PATCH HERE
  #           <- DoKrispInitialize() hop 4 (only caller of hop 3)
  #              ^^^ has multiple callers, so the chain fans out

Useful commands for poking at a binary yourself:
  otool -f discord_krisp.node                                     # fat header
  otool -arch x86_64 -l discord_krisp.node                        # load commands
  otool -arch x86_64 -Iv discord_krisp.node | grep SecStaticCode  # stub lookup
  nm -arch x86_64 discord_krisp.node | c++filt | grep -i sign     # signing symbols
  objdump -d --start-address=0x4754c0 --stop-address=0x475580 discord_krisp.node
"""

import mmap
import sys
from bisect import bisect_right
from dataclasses import dataclass
from typing import Iterator, TypeVar

import capstone
import lief

T = TypeVar("T")


def _first(gen: Iterator[T], err: str) -> T:
    """Return first item from gen, or raise SystemExit with err."""
    if (result := next(gen, None)) is None:
        raise SystemExit(err)
    return result


@dataclass(frozen=True)
class Arch:
    """Per-CPU disassembler settings and the "return true" patch bytes."""

    name: str
    cs_args: tuple
    return_true: bytes


_X86_64 = lief.MachO.Header.CPU_TYPE.X86_64
_ARM64 = lief.MachO.Header.CPU_TYPE.ARM64

ARCHS: dict = {
    _X86_64: Arch(
        name="x86_64",
        cs_args=(capstone.CS_ARCH_X86, capstone.CS_MODE_64),
        return_true=b"\xb8\x01\x00\x00\x00\xc3",  # mov eax, 1; ret
    ),
    _ARM64: Arch(
        name="arm64",
        cs_args=(capstone.CS_ARCH_ARM64, capstone.CS_MODE_LITTLE_ENDIAN),
        return_true=b"\x20\x00\x80\x52\xc0\x03\x5f\xd6",  # mov w0, #1; ret
    ),
}

# Direct-branch mnemonics we follow when building the caller index. We skip
# conditional branches (b.eq, jne, cbz, ...) since those encode intra-function
# control flow rather than call edges
DIRECT_BRANCHES = frozenset({"b", "bl", "call", "jmp"})

# MD5-hash comparison idiom inside IsSignedByDiscord (ELF path):
#   pmovmskb %xmm0,%eax ; cmp $0xffff,%eax
ELF_SIG = b"\x66\x0f\xd7\xc0\x3d\xff\xff\x00\x00"

# Apple Security framework import used as the Mach-O call-chain anchor
ANCHOR_IMPORT = "_SecStaticCodeCreateWithPath"


@dataclass(frozen=True)
class FunctionStarts:
    """Sorted function starts with a helper for address-to-function lookup."""

    addrs: tuple[int, ...]

    @classmethod
    def from_lief(
        cls,
        binary,
        start: int | None = None,
        end: int | None = None,
    ) -> "FunctionStarts":
        addrs = tuple(
            sorted(
                f.address
                for f in binary.functions
                if (start is None or start <= f.address)
                and (end is None or f.address < end)
            )
        )
        if not addrs:
            raise SystemExit("Error: no function starts found")
        return cls(addrs)

    def containing(self, addr: int) -> int | None:
        idx = bisect_right(self.addrs, addr) - 1
        if idx < 0:
            return None
        return self.addrs[idx]

    def require_containing(self, addr: int) -> int:
        if (fn := self.containing(addr)) is None:
            raise SystemExit(f"Error: no function contains address 0x{addr:x}")
        return fn


def _apply_patch(mm: mmap.mmap, off: int, patch: bytes, label: str) -> None:
    state = (
        "already patched"
        if mm[off : off + len(patch)] == patch
        else "patched -> return true"
    )
    mm[off : off + len(patch)] = patch
    print(f"[krisp-patcher] {label}: {state}")


def _build_xrefs(
    data: bytes,
    text_vm: int,
    arch: Arch,
    functions: FunctionStarts,
) -> dict[int, set[int]]:
    """Disassemble ``data`` (the __text section) once and index direct-branch
    targets by the function containing the branch

    Returns ``{target_vaddr: {start addresses of calling functions}}``. The
    containing function for a branch comes from ``functions``.
    """
    md = capstone.Cs(*arch.cs_args)
    md.detail = True
    # __text contains jump tables and other data interleaved with code on x86
    # (ARM64 is fixed-width so the sweep stays aligned regardless). Without
    # skipdata, capstone's linear sweep stops at the first undecodable byte,
    # often within a few KB. Skipdata resyncs one byte at a time
    md.skipdata = True
    xrefs: dict[int, set[int]] = {}
    for insn in md.disasm(data, text_vm):
        if insn.mnemonic not in DIRECT_BRANCHES:
            continue
        op = insn.operands[0] if insn.operands else None
        if op is None or op.type != capstone.CS_OP_IMM:
            continue
        if (fn := functions.containing(insn.address)) is None:
            continue
        xrefs.setdefault(op.imm, set()).add(fn)
    return xrefs


def _unique_match(
    mm: mmap.mmap, needle: bytes, start: int, end: int, label: str
) -> int:
    idx = mm.find(needle, start, end)
    if idx == -1 or mm.find(needle, idx + 1, end) != -1:
        raise SystemExit(f"Error: expected exactly 1 {label} match")
    return idx


def _macho_import_stub(binary, section, name: str) -> int:
    """Return the vaddr of an imported symbol's lazy-bind stub."""
    stub_size = section.reserved2
    n_stubs = section.size // stub_size if stub_size else 0
    indirect = list(binary.dynamic_symbol_command.indirect_symbols)
    return _first(
        (
            section.virtual_address + i * stub_size
            for i in range(n_stubs)
            if section.reserved1 + i < len(indirect)
            and name in indirect[section.reserved1 + i].name
        ),
        f"Error: {name} stub not found",
    )


def _walk_unique_callers(
    xrefs: dict[int, set[int]],
    target: int,
    label: str,
) -> int:
    """Follow the single-caller chain and return the last unique caller."""
    hop, previous = 0, target
    while len(callers := xrefs.get(target, ())) == 1:
        previous, target, hop = target, next(iter(callers)), hop + 1
        print(f"[krisp-patcher] {label}: hop {hop} -> 0x{target:x}")
    if hop < 2:
        raise SystemExit("Error: call chain too short (expected >= 2 hops)")
    return previous


def patch_elf(mm: mmap.mmap, path: str) -> None:
    binary = lief.ELF.parse(path)
    text = binary.get_section(".text")
    if text is None:
        raise SystemExit("Error: .text not found")
    text_off, text_sz = text.file_offset, text.size
    # Offset between file offset and vaddr within .text (constant across the section)
    text_delta = text.virtual_address - text_off

    idx = _unique_match(mm, ELF_SIG, text_off, text_off + text_sz, "signature")

    # binary.functions is populated from .eh_frame unwind info, which is
    # present even in stripped binaries. Bisect picks the containing function
    functions = FunctionStarts.from_lief(binary)
    func_vaddr = functions.require_containing(idx + text_delta)
    func_off = func_vaddr - text_delta

    print(f"[krisp-patcher] ELF: signature at 0x{idx:x}, function at 0x{func_off:x}")
    _apply_patch(mm, func_off, ARCHS[_X86_64].return_true, "ELF")


def patch_macho_slice(mm: mmap.mmap, binary: "lief.MachO.Binary") -> None:
    """Trace _SecStaticCodeCreateWithPath up the call chain and patch the
    last uniquely-reachable function."""
    arch = ARCHS[binary.header.cpu_type]
    base = binary.fat_offset

    text = binary.get_section("__text")
    text_vm, text_sz, text_off = text.virtual_address, text.size, text.offset
    fstart = base + text_off

    stubs = binary.get_section("__stubs")

    target = _macho_import_stub(binary, stubs, ANCHOR_IMPORT)

    # Sorted function starts; bisect maps any __text address to its function.
    # binary.functions merges symbols + __unwind_info so it covers stripped
    # functions too
    functions = FunctionStarts.from_lief(binary, text_vm, text_vm + text_sz)

    # One disassembly pass; each hop up the chain is an O(1) dict lookup
    xrefs = _build_xrefs(bytes(mm[fstart : fstart + text_sz]), text_vm, arch, functions)

    patch_addr = _walk_unique_callers(xrefs, target, f"Mach-O {arch.name}")
    _apply_patch(mm, fstart + (patch_addr - text_vm), arch.return_true, arch.name)


def main() -> None:
    if len(sys.argv) < 2:
        raise SystemExit(f"Usage: {sys.argv[0]} <discord_krisp.node>")
    path = sys.argv[1]
    with open(path, "r+b") as f, mmap.mmap(f.fileno(), 0) as mm:
        if mm[:4] == b"\x7fELF":
            patch_elf(mm, path)
        else:
            fat = lief.MachO.parse(path)
            for binary in fat:
                patch_macho_slice(mm, binary)


if __name__ == "__main__":
    main()
