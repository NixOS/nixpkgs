# Compiler and linker wrapper design

This document is for maintainers of `cc-wrapper`, `bintools-wrapper` and the
compiler patches that support them. It records the problem the wrappers solve,
the constraints any change must respect, the current architecture, and the
direction accepted for its evolution.

The user-facing contract is the [CC Wrapper](../../../doc/stdenv/stdenv.chapter.md#cc-wrapper)
section of the manual. Validation status for the CUDA integration that motivated
this work is recorded in [`cuda-modules/review`](../../development/cuda-modules/review/README.md).

Status as of 2026-10-13:

- The policy record, invocation kinds and executable-carried toolchain policy
  are implemented.
- Native compiler capability is implemented for the versions listed under
  [Native capability](#native-capability).
- A native linker prototype was reviewed and withdrawn; see
  [Consequences for in-progress work](#consequences-for-in-progress-work).
- The [generic contract](#decision-generic-contract-native-refinement) is
  accepted but not implemented.

## The problem

A wrapper invocation combines three things:

1. **Caller inputs**: `NIX_CFLAGS_COMPILE_<salt>`, `NIX_LDFLAGS_<salt>` and
   related variables. Setup hooks set them per dependency role during a build;
   they are absent outside stdenv.
2. **Toolchain policy**: files in the wrapper's `nix-support/` directory (libc
   and C++ headers, crt files, the dynamic loader, hardening defaults).
3. **The operation**: arguments, response files and environment.

Part of the policy is conditional on the operation:

- link flags apply only when linking;
- the C++ runtime applies only to the C++ driver;
- libc headers are omitted for `-nostdinc`;
- the loader and RPATH apply only to dynamic links.

Applying that part correctly requires knowing what the invocation does, which is
defined by each driver's own argument grammar.

The previous design failed in three ways:

1. **It mutated caller inputs.** `add-flags.sh` prepended toolchain defaults to
   the caller's variables and exported `NIX_CC_WRAPPER_FLAGS_SET_<salt>`. A
   nested wrapper (NVCC's backend compiler, `gnatmake`'s compiler, a hook's
   compiler call) inherited partially prepared state.
2. **It classified invocations approximately.** A shell `case` scan over the
   arguments misreads option operands (`-o -c`), quoting inside response files,
   forwarded options (`-Wp,-nostdinc`), and driver modes supplied through policy.
3. **It decided link-mode policy too early.** `-static-pie` inside a response
   file in `NIX_CFLAGS_LINK` still received a dynamic loader, producing an
   executable with `PT_INTERP` that crashes.

## Constraints

Any design must satisfy all of these:

- **Policy travels with the executable.** JIT compilers (PyTorch
  `cpp_extension`, Triton, PyCUDA, installed NVCC), `nix shell`, clangd's
  `--query-driver`, and CMake or Meson compiler probes never run setup hooks.
  Toolchain policy therefore cannot depend on stdenv activation; only
  per-dependency flags may come from setup hooks.
- **Any compiler a user can select must work.** This includes overridden
  versions; GCC older than 14 and Clang outside 19–23; prebuilt vendor
  toolchains (Nixpkgs' `gcc-arm-embedded-{13,14,15}` are ARM's binary
  releases); the bootstrap-tools compiler; launchers such as ccache; and
  `nativeTools`. None of these can carry Nixpkgs patches.
- **Valid invocations stay transparent.** Argument order, response-file grammar,
  query output (`-print-*`, `-v`, `-dumpmachine`), exit status and the absence of
  new diagnostics under `-Werror` must match the raw driver, apart from the
  intended policy.
- **Roles are not visible in arguments.** One executable can serve BUILD and
  HOST; invoking it through `CC_FOR_BUILD` does not identify a role.
- **Delegation must not lose or duplicate policy.** Multi-job drivers (NVCC,
  GNAT, Swift) run further compiler and linker jobs.
- **Bootstrap is minimal.** Early stages have the bootstrap shell, the bootstrap
  tools and an unpatched compiler.
- **Cost matters.** Wrappers run millions of times per rebuild, and every
  patched tool must be rebased on each release.
- **Embedded targets differ.**
  - GCC selects multilib directories inside the driver from `-mcpu`,
    `-mfloat-abi` and similar options.
  - Specs files such as `nano.specs` are routine.
  - Bare-metal targets have no dynamic loader, and `-nostdlib` and `-T` are
    common.
  - These targets are not Linux, so the Linux-only native header bindings do not
    apply even to embedded compilers built from source.

## Current architecture

### Policy record and invocation kinds

Caller inputs are never written. The selected policy lives in private `wrapper_*`
variables (`utils.bash`).

- A public entry is a **fresh invocation**. `wrapperClear` discards inherited
  policy, and the wrapper selects its own roles and defaults from the unchanged
  caller inputs.
- A **continuation** (`wrapperImport`) reuses a parent's selection for the
  actual child operation without selecting defaults again.
- Multi-job drivers delegate through the prepared entries
  `nix-support/compiler` and `nix-support/linker` instead of re-entering public
  wrappers.
- `wrapperRun` exports the record only when delegating, and clears it otherwise.

### Executable-carried toolchain policy

libc and C++ headers, crt files, the loader and the hardening defaults come from
`nix-support/*` on every invocation. They apply to JIT compilation and other use
outside stdenv. Per-dependency flags remain caller inputs; outside stdenv a
consumer passes them explicitly.

### Native capability

A compiler package declares `nativePrimaryQuery = "fd-v3"` when its driver
implements the primary query. The cc-wrapper constructor then lists the exact
raw executables it wraps in `nix-support/native-primary-programs`, one store
path per line. Capability is keyed by that path, so an override or launcher
does not inherit it.

| Compiler | Gate | Native interfaces |
| --- | --- | --- |
| GCC | ≥ 14, Unix host | primary query (`fd-v3`); `-fdefault-include-map` default-header binding |
| Clang | 19–23, Unix host | primary query (`fd-v3`); driver default-header table |

The default-header bindings apply on non-Android Linux only. The query uses
`nix-primary-v3` records over `NIX_CC_PRIMARY_ARGS_FD` and
`NIX_CC_PRIMARY_QUERY_FD`, defined by `cc-wrapper/primary-query.sh` and the
GCC and Clang `native-primary-query` patches.

On the native path the wrapper:

1. runs the raw driver once in query mode, which classifies the operation with
   the driver's own parser;
2. adds policy;
3. runs the driver again with the raw argument groups, which it expands and
   interprets natively.

Response files can therefore be read twice. Wrapper hooks run on both paths; on
the native path they see the raw caller arguments, which the driver interprets
again at final execution.

### Legacy path

Every other compiler uses the shell scan in `cc-wrapper.sh` and the argument
scan in `ld-wrapper.sh`. Its semantics differ from the native path. For example,
purity and no-native filtering happen before hooks rather than on the driver's
expanded arguments.

## Decision: generic contract, native refinement

Accepted 2026-10-13:

1. **The contract is generic.** It is defined by mechanisms that every GCC- or
   Clang-family driver already provides, including vendor forks, prebuilt
   releases, older versions and the bootstrap compiler.
2. **Native capability is a refinement.** It may add exactness for the cases
   listed under [Limits](#limits-of-the-generic-tier), but ordinary invocations
   must produce the same result with or without it. A compiler override must not
   silently change wrapper semantics.
3. **The shell scan is a last resort.** It remains only for compilers that are
   neither GCC- nor Clang-like.

Rationale:

- The constraints above make patched compilers the exception rather than the
  rule.
- Today an override silently switches between two semantic regimes.
- The patches span GCC 14–16, Clang 19–23 and Swift's LLVM fork, so each
  release needs a rebase.

### Generic mechanisms

#### Driver-interpreted policy

Conditional policy is expressed in a form the driver evaluates with its own
parser, instead of being classified by the wrapper.

- **GCC: specs files** (`-specs=`).
  - Conditions such as `%{!nostdinc:…}` and `%{!nostdlib:%{!nodefaultlibs:…}}`
    are supported, and link-only flags belong in the link and library specs.
  - GCC gates its own loader this way. The built-in link spec of GCC 15.2 for
    `aarch64-unknown-linux-gnu` contains
    `%{!static:%{!static-pie:… %{!shared:-dynamic-linker …}}}`.
  - Embedded toolchains already rely on specs files.
- **Clang: configuration files** (`--config=`).
  - Head options precede the command line.
  - Options prefixed with `$` form a tail list that the driver adds as linker
    inputs only when its own final phase is Link. This was verified in LLVM 23's
    `clang/lib/Driver/Driver.cpp`. LLVM 19 has a single configuration list, and
    releases 20–22 have not been checked.
  - The driver claims all configuration options, so they never trigger
    unused-argument diagnostics.
  - Default configuration files are keyed by driver mode, for example
    `clang++.cfg` or `<triple>-clang++.cfg`, which gives C++ defaults without
    classification.

#### Driver dry run

`-###` prints the jobs a driver would run without running them. From it, a
wrapper can read:

- whether a link job exists and which linker it uses;
- whether `cc1` or `cc1plus` runs;
- forwarded `-nostdinc`;
- an added `-lstdc++`.

It costs one extra driver execution, which the native query already pays. Its
output is informal text.

#### Link-mode policy at the linker

By the time the linker runs, the driver has translated the link mode, whichever
channel supplied it.

- For `-static-pie`, Clang passes `-static -pie --no-dynamic-linker -z text`.
- GCC 15.2's built-in spec passes `-Bstatic -pie --no-dynamic-linker -z text`.

The common signal is `-pie` together with `--no-dynamic-linker`; `-Bstatic` alone
is a per-library toggle, not a mode.

In both lld (`getDynamicLinker`) and GNU ld (`parse_args` in `ld/lexsup.c`), the
last of `-dynamic-linker` and `--no-dynamic-linker` wins.

A loader the compiler wrapper passes through `-Wl` reaches the linker after the
driver's own `--no-dynamic-linker`, so it wins; that is the static-PIE defect.
Emitting the loader only in the ld-wrapper would lose it for links that reach an
unwrapped linker, for example `-fuse-ld=lld` with an unwrapped lld on `PATH`,
which the contract supports. The generic fix therefore lets the driver emit the
loader, conditioned on its own link mode:

- **GCC:** a specs file appends `%{!static:%{!static-pie:%{!shared:-dynamic-linker
  <loader>}}}` to the link spec. A `%{m32:…}` alternative selects the 32-bit
  loader. Still to verify: that the appended spec reaches the linker after
  GCC's built-in loader and before caller `-Wl` options.
- **Clang:** the driver already emits `-dynamic-linker` only for dynamic links
  (`clang/lib/Driver/ToolChains/Gnu.cpp`). With `--dyld-prefix=<libc>`, that
  path points into the selected libc; Nixpkgs' 64-bit glibc provides the `lib64`
  symlink that Clang's x86-64 path expects. Clang derives the loader name
  itself, so an arbitrary `NIX_DYNAMIC_LINKER` cannot be expressed this way, and
  the recorded interpreter path changes (`lib64` rather than `lib` on x86-64).
- **ld-wrapper:** classifies the final mode from the linker's own arguments
  (`-pie` with `--no-dynamic-linker` means static PIE) instead of inheriting
  the compiler wrapper's guess (`wrapper_NIX_LINK_TYPE`), drops policy RPATH
  entries for static outputs, and keeps placing its own loader before the
  driver's arguments.

The compiler wrapper stops passing its own loader for drivers that emit one
this way.

#### Executable-carried policy

Specs and configuration files live in `nix-support/`, so these mechanisms work
for JIT compilation without stdenv.

### Limits of the generic tier

These still require native cooperation:

- **Replacing the default header providers with native semantics.** This means
  keeping `-nostdinc` (including `-Wp,-nostdinc`), search-group order,
  system-header classification and `#include_next` behavior.
  - Clang has no runtime interface for this.
  - A GCC spec guarded by `nostdinc` misses `-Wp,-nostdinc`, because the
    frontend applies that option.
  - The requirement exists because Nixpkgs selects libc separately from the
    compiler. Self-contained vendor toolchains find their own headers.
- **Per-argument provenance through native response-file expansion.** Purity
  filtering of expanded arguments and origin-aware RPATH depend on it.
- **C++ link groups under `-nostdlib`.** A Clang tail cannot honor `-nostdlib`
  for a C++ link group, because tail options are added as ordinary linker
  inputs.

### Consequences for in-progress work

- **The native linker prototype was withdrawn.** It was reviewed on
  2026-10-13 without being built. It moved the loader and RPATH policy into
  compiler-side `-Xlinker` arguments, labelled every argument with its origin,
  and relied on patched lld 21 and GNU ld to discard policy entries by label.
  The review found:
  - with any other linker (lld other than 21, gold, mold, a non-Linux host or
    a non-ELF target), static and static-PIE links regained an interpreter and
    RUNPATH;
  - multilib `-m32` links lost the 32-bit loader;
  - compiler jobs delegated through `nix-support/compiler` never sent the
    labels;
  - it patched libLLVM's public command-line expansion API, which rebuilds
    every LLVM consumer.

  The same labels carried caller-aware purity and no-native filtering for
  Clang's native path, and that refinement was withdrawn with it.
- **The static-PIE defect should be fixed in the generic tier**, by letting
  the driver emit the loader as described above.
- **The legacy shell classification should be replaced** for GCC- and
  Clang-family drivers by driver-interpreted channels, with or without `-###`.
- **The native and generic paths must agree on ordinary inputs.** Known
  divergence: where purity and no-native filtering apply.

### Open questions

- Whether `-###` is needed, or driver-interpreted channels and the linker
  boundary suffice.
- How a constructor identifies a GCC- or Clang-family driver. The existing
  `isGNU` and `isClang` metadata covers Nixpkgs-built compilers; vendor forks
  need an explicit declaration.
- Whether each role should get its own executable, so that `CC_FOR_BUILD`
  selects BUILD policy without relying on the environment.
- Darwin (ld64) and MinGW, where the native frames' POSIX descriptors are not
  available.
