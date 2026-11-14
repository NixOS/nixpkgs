# Compiler and linker wrapper design

This document is for maintainers of `cc-wrapper`, `bintools-wrapper` and the
compiler patches that support them. It records the problem the wrappers solve,
the constraints any change must respect, the current architecture, and the
direction accepted for its evolution.

The user-facing contract is the [CC Wrapper](../../../doc/stdenv/stdenv.chapter.md#cc-wrapper)
section of the manual. Validation status for the CUDA integration that motivated
this work is recorded in [`cuda-modules/review`](../../development/cuda-modules/review/README.md).

Implementation status:

- The policy record, invocation kinds and executable-carried toolchain policy
  are implemented.
- Native compiler capability is implemented for the versions listed under
  [Native capability](#native-capability).
- A native linker prototype was reviewed and withdrawn; see
  [Consequences for in-progress work](#consequences-for-in-progress-work).
- Role selection and policy transport apply to native-capable and legacy drivers.
  Native primary interpretation and default-header bindings refine that shared
  mechanism. Link policy uses primary option metadata and the compatibility
  scan described under [Link-mode policy](#link-mode-policy).

Implementation status is separate from producer acceptance; the linked CUDA
integration review records exact builds, bounded controls and pending checks.

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

The previous design had two problems addressed here:

1. **It mutated caller inputs.** `add-flags.sh` prepended toolchain defaults to
   the caller's variables and exported `NIX_CC_WRAPPER_FLAGS_SET_<salt>`. A
   nested wrapper (NVCC's backend compiler, `gnatmake`'s compiler, a hook's
   compiler call) inherited partially prepared state.
2. **It classified invocations approximately.** A shell `case` scan over the
   arguments misreads option operands (`-o -c`), quoting inside response files,
   forwarded options (`-Wp,-nostdinc`), and driver modes supplied through policy.

Link-mode policy has a separate, inherited limit: modes hidden in conditional
compiler-policy response files or introduced after policy selection can receive
incompatible loader or RPATH flags. The primary interface does not determine
final linker output, and this work does not repair that general problem.

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
  intended policy. Native framing requires repeatable driver inputs as
  described under [Primary interpretation and execution](#primary-interpretation-and-execution).
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

Caller flag inputs are not overwritten with computed policy. The selected policy
lives in private `wrapper_*` variables (`utils.bash`); directly consumed environment
values are projected separately, as described in the manual.

- A public compiler entry is a **fresh invocation**. `wrapperClear` discards
  inherited policy, and the wrapper selects its own roles and defaults from the
  unchanged caller inputs.
- A **continuation** (`wrapperImport`) reuses a parent's selection for the
  actual child operation without selecting defaults again.
- Multi-job drivers delegate through the prepared entries
  `nix-support/compiler` and `nix-support/linker` instead of re-entering public
  wrappers.
- `wrapperRun` exports the record only when delegating, and clears it otherwise.

After recording the link mode for which the compiler rendered its main linker flags, transport preserves every present scalar field, including empty values, without a second encoding or a field registry; an absent field remains absent. Policy fields must not be Bash arrays, which cannot be exported through the environment.

Public linkers import inherited link records, even beneath compile-only compiler
requests. The record cannot identify individual child jobs. Custom launchers must
unset `NIX_WRAPPER_OPERATION` only for independent public linker invocations
(for example, in a subshell), preserving it for the driver's intended linker.
The independent invocation then selects its own roles, caller inputs and defaults.

#### Role composition

Role-indexed contributions combine pointwise: `(P <> Q)(r) = P(r) ++ Q(r)`.
Selecting one role retains precisely that role's contributions and preserves their order and the empty contribution.
Full preparation adds salted inputs and toolchain defaults once, after selection.
These laws concern contribution sequences: separator insertion in `mangleVarListGeneric` is not associative when an explicitly empty input follows a nonempty one.
Concatenating several selected roles does not have that property: selecting BUILD and HOST from `a` and then `b` yields `aB aH bB bH`, whereas combining first yields `aB bB aH bH`.
The current wrapper uses the latter, role-major order; moving that union before collection can change header or library resolution.
Retain the role-indexed contributions through composition, and perform any compatibility union at the final boundary.
Package selection and invocation binding must agree on an explicit context; this does not replace construction of a coherent transitive package graph.
A context must distinguish resource uses within one invocation: CMake needs executable programs for BUILD and packages for the configured platform.
Nixpkgs' existing `NIXPKGS_CMAKE_PREFIX_PATH` interface excludes program lookup for this reason.
Likewise, a CUDA device job can need the CPU host's C++ headers: Clang's [CUDA toolchain delegates header lookup to its host toolchain](https://github.com/llvm/llvm-project/blob/llvmorg-21.1.8/clang/lib/Driver/ToolChains/Cuda.cpp), so the job's output target alone does not identify its resource uses.

### Executable-carried toolchain policy

libc and C++ headers, crt files, the loader and the hardening defaults come from
`nix-support/*` on every invocation. They apply to JIT compilation and other use
outside stdenv. Per-dependency flags remain caller inputs; outside stdenv a
consumer passes them explicitly.

### Native capability

A compiler package declares `nativePrimaryQuery = "fd-v3-link-policy"` when its driver
implements the primary query including `link_policy`. The older `fd-v3`
capability does not guarantee that field. The constructor enables the interface
only for the exact capability above; other values select the legacy path.
It lists the exact
raw executables it wraps in `nix-support/native-primary-programs`, one store
path per line. Capability is keyed by that path, so an override or launcher
does not inherit it.

| Compiler | Gate | Native interfaces |
| --- | --- | --- |
| GCC | ≥ 14, Unix host | primary query; `-fdefault-include-map` default-header binding |
| Clang | 19–23, Unix host | primary query; driver default-header table |

The default-header bindings apply on non-Android Linux only. The query uses
`nix-primary-v3` records over `NIX_CC_PRIMARY_ARGS_FD` and
`NIX_CC_PRIMARY_QUERY_FD`, defined by `cc-wrapper/primary-query.sh` and the
GCC and Clang `native-primary-query` patches.

#### Primary interpretation and execution

For raw compilers advertising the native primary-argument interface, selection is acyclic.
First, the native driver interprets the unconditional BEFORE arguments, caller arguments, and compile arguments to select its personality; the GCC language driver supplies its compiled-in personality, while Clang also interprets `--driver-mode` and its native debug rewrite.
The wrapper selects the opaque caller C++ compile channel once, then asks that same native parser for the requested host operation and invocation-wide support-group applicability with that channel included.
Only then does it insert suppressible defaults and conditional link channels in their original positions.
A conditional channel or a late hook can still change the final native invocation, but cannot recursively select another wrapper policy.
For example, a C invocation with `NIX_CFLAGS_LINK=--driver-mode=g++` and `NIX_CXXSTDLIB_COMPILE=-c` has no consistent recursive choice: selecting the link channel would select C++ compilation, which would remove the link channel.
The primary interpretation therefore excludes the conditional link channel.
This describes the requested host operation, not successful execution or every device-packaging job; an archive or CUDA fatbin is not a host image link.
The query also reports `link_policy=dynamic|static|static-pie` from the primary
parsed driver options, selecting `static-pie` when that option is present.
This metadata preserves interpretation
of ordinary caller response files without adding job construction or decoding
job output. GCC's existing primary-operation query still walks driver specs
with command execution suppressed. Specs that depend on files generated by
those commands can therefore select a different plan during final execution.
The metadata does not describe conditional
link channels or final ELF layout.

The primary request must be parseable before conditional default/link fragments and the late hook are inserted.
An explicit caller frontend entry bypasses compiler/linker argument contributions (the selected SDK environment is retained); introducing a frontend entry through primary policy is rejected rather than discarding that policy.
Consequently, supplying an option's missing operand only through such a fragment is outside this interface; options and operands must be supplied together.
The wrapper retains raw caller arguments through hooks and sends ordered argument groups to the native driver for both primary interpretation and final execution.
Clang first checks the caller's standalone native frontend entry, including caller response files, without reading policy response files or applying their quoting selectors.
For an ordinary driver entry it interprets the original groups using the combined native response-file grammar; selected C++ compile arguments participate in the subsequent primary interpretation.
The native handler selects immediate actions for both queries and execution; queries skip the selected action's body.
Final execution reads the raw groups again, expands response files natively, and positions suffix arguments before a parser-recognized caller `--` boundary.
These are separate interpretation epochs, not a promise to read each response file once or freeze its contents across hooks.
Native framing does not preserve the legacy wrapper's support for one-shot response streams such as FIFOs or piped `@/dev/stdin`; write these arguments to a regular response file first.
Framed Clang requires repeatable regular response/configuration inputs; `@` response inputs also accept the empty null device and its aliases. This differs from raw Clang as well.
Its guard covers driver preparation, including initial toolchain discovery; final actions and job construction use the ordinary filesystem. GCC retains its native libiberty response and specs readers; nonregular inputs can fail or block without Clang's explicit guard diagnostic.
Ordinary source stdin is unaffected, as is `@/dev/stdin` redirected from a regular file.
Native unresolved `@file` fallback remains unchanged: the token can name a literal file or become a response file before final execution.
Resources needed to parse the primary request must be available then; later changes can change final native behavior but do not retroactively select wrapper policy.
Purity and no-native filtering operate at the native expanded-argument boundary, including final hook changes. Clang uses the selected mode's native option visibility, including CL, DXC and Flang, rather than rejecting those modes.
Native option-grammar support does not translate opaque GNU C toolchain flags or hardening policy for non-GNU personalities, including CL, Flang and DXC. Mode-specific tests retain constructor defaults but isolate incompatible inherited channels and supply compatible explicit policy.
In CL mode, the configured target is retained instead of being replaced by Clang's default Windows target, as with the earlier wrapper `-target` prefix. Explicit command-line/configuration targets, including `/clang:` forwarding, still override it; machine defaults are selected after that forwarding is interpreted.
For caller-owned options it retains ownership through `-Xarch_*` scoped payloads and the destination streams formed by `-Xclang`, `-Xpreprocessor`/`-Wp,`, `-Xclangas` where supported, and recursive `/clang:` forwarding.
Each complete destination stream is parsed natively, so an option and its operand can come from separate carriers without promoting option-shaped operand text into an option. Policy-owned options remain policy-owned.
The raw mode before response expansion selects the native response tokenizer and whether `CL`/`_CL_` are read; the expanded mode selects option visibility. Thus `--driver-mode=cl` introduced only inside a response file selects CL option grammar without activating CL environment inputs, and a raw CL entry retains its environment decision even if a response file changes the effective mode.
When activated, `CL` and `_CL_` retain native Windows tokenization and `#`-to-`=` conversion, with caller ownership before and after the trusted policy groups respectively. Filtering waits until the native stream is merged, preserving operands supplied across those sources and native macro ordering.
The filtering policy remains the recognized `-I`, `-L`, `-isystem` paths and native-valued machine options; this is not general provenance tracing through arbitrary configuration, specs or plugin transformations. The legacy path retains its earlier shell filtering.
Clang's initial personality observes its native debug rewrite, and final execution applies that rewrite to its final arguments.
`-x` and `-x none` remain native per-input language selectors: `gcc -x c++` does not acquire implicit C++ runtime policy, while `g++ -x c` retains its driver policy.
These caller channels apply to the whole invocation, so their options must be valid for every job in a mixed-language invocation; use separate compiler invocations for incompatible per-language options.
Mutable support-file contributions remain opaque invocation groups: unqualified `-nostdinc` omits the libc group; `-nostdinc` or `-nostdinc++` omits the C++ compile group; and `-nostdlib` omits the C++ link group.
Native options carried as operands of `-Xarch_host` or `-Xpreprocessor` do not accidentally suppress an entire group.
Likewise, `-nodefaultlibs`, `-nostdlib++`, and `-nostdlibinc` retain opaque group additions while the native compiler applies their own per-job semantics to typed header and runtime providers.
Explicit caller policy remains separate from these groups.
Clang's C driver can discover C++ headers without receiving a caller's `-std=c++17`, while native default-header bindings retain per-job language selection.

#### Default-header providers

Resource bindings must preserve native lookup semantics, including where options take effect.
[GCC's `register_include_chains`](https://github.com/gcc-mirror/gcc/blob/releases/gcc-13.3.0/gcc/incpath.cc) applies default-header suppression in the frontend; a driver spec guarded by `nostdinc` therefore misses forwarded `-Wp,-nostdinc`.
On non-Android Linux, the GCC 14+ wrapper binds bundled or separately packaged GNU C++ headers and the selected target's libc headers through `-fdefault-include-map`.
GCC replaces those two default families in its configured include table, retaining compiler-private, tool, and platform entries in their native order; it then preserves per-input language choice, frontend suppression, system-header status, and `#include_next` on the original providers.
The selected providers use absolute store paths without relocation, sysroot rewriting, or multilib suffixes; a mapped provider cannot change when GCC is invoked with `-iprefix` or relocates its driver.
Fortify's wrapper headers retain their position before other system include inputs through `-idefaultsystem`, which the frontend also removes for `-nostdinc`.
GFortran interprets that option in its preprocessor's bracket include chain, matching its existing treatment of `-isystem` while honoring `-nostdinc`.
The binding lives in the compiler wrapper and therefore applies to a JIT compiler invocation even when no stdenv setup hook ran.
Clang's GNU toolchain instead selects C++ defaults in the driver: `-Xpreprocessor -nostdinc++` does not remove those already supplied paths, unlike GCC.
A common frontend filter would change that behavior.
Nixpkgs' Clang `-nostdlibinc` also suppresses host-system discovery before selected headers are supplied; replacing discovery and suppressing selected defaults are different operations.
Clang's [`-stdlib++-isystem`](https://github.com/llvm/llvm-project/blob/llvmorg-21.1.8/clang/lib/Driver/ToolChain.cpp) deliberately survives `-nostdinc` and `-nostdlibinc`, so it is not an equivalent default-header binding.
On non-Android Linux, the Clang 19–23 wrapper supplies the same selected C++ and libc providers to a driver table keyed by normalized target triple, where missing target/library pairs mean empty providers rather than ambient fallback.
A wrapper whose linker has a 32-bit loader also binds those providers for `i386-unknown-linux-gnu`, the target Clang selects for `-m32`.
The driver retains Clang's per-job standard-library choice and `-nostdinc`/`-nostdlibinc`/`-nostdinc++` semantics; the wrapper omits its automatic `-nostdlibinc` because the binding itself removes ambient libc discovery.
For a selected libc++, the wrapper supplies one `-stdlib=libc++` default before caller arguments, so an explicit `-stdlib` selects the requested map family.
Clang renders `-idefaultsystem` in place among system include options and omits it when the caller supplies `-nostdinc` or `-nostdlibinc`.

Toolchain defaults, explicit paths, and opaque driver arguments must remain distinguishable.
`NIX_CXXSTDLIB_COMPILE` is not a directory list: `libedgetpu` supplies `-std=c++17`, while generated `libcxx-cxxflags` can also contain macro-prefix maps; arbitrary driver options cannot simply be forwarded to `cc1plus`.
Clang's [header-option parser](https://github.com/llvm/llvm-project/blob/llvmorg-21.1.8/clang/lib/Frontend/CompilerInvocation.cpp) represents `-isystem p` and `-internal-isystem p` with identical entry fields; that representation alone cannot recover their origin.

Header lookup observes the selected file, pathname after prefix mapping, native header classification, and the remaining `#include_next` chain.
Retain search groups through composition: `-I a -I b -isystem a` searches `b` first because native resolution removes `a` from the ordinary include group.
Flattening directories before that resolution loses this behavior.
A synthetic directory of header symlinks can visit the original provider again through `#include_next`, change `__FILE__`, and bypass prefix maps.
Binding original providers must preserve these observations; passing compilation tests or finding a native configuration option does not establish equivalence.

### Delegated jobs and importers

Multi-job drivers bind a **toolchain request** and choose an interpreter at each actual job boundary.
The `nix-support/compiler` and `nix-support/linker` entries accept that request, a raw executable, and its arguments; they expand response files before interpreting the job when the response-file helper is available (it can be omitted during bootstrapping).
GNAT uses program-bound entries to preserve each tool's own operation: selecting `gnatlink` does not suppress that child's subsequent compiler selection.
Swift delegates generated compiler-driver link jobs to its adjacent public Clang wrapper.
The native Swift driver has not selected Nix compiler or linker policy, so these jobs start fresh; their generated arguments and response files determine the operation.
Swift's Clang importer reads the adjacent compiler's header provider configuration before explicit importer arguments.
Its ordinary path uses Clang's driver interpreter; direct cc1 module jobs already contain lowered arguments and do not repeat that selection.

The wrapper's `importerFlags` metadata names support files relative to `nix-support`.
Its `driver` configuration is derived from the selected providers for both mapped GNU and Clang wrappers. It preserves native default-header suppression and standard-library selection in matching patched Clang driver APIs; pass it with `--config` so explicit arguments take precedence. An independently overridden, unpatched libclang does not acquire that interface from the outer compiler.
The `libc` and `cxx` files instead expose explicit selected-provider paths for tools whose interface is a header search path, such as `CPATH`.
Those explicit paths do not acquire native default suppression or switch providers when an independent `-stdlib` option changes.
The original compiler support files remain mutable; importer users may customize the corresponding importer file, and ordinary `cc-cflags` remains a separate input where that consumer supports it.
Arbitrary compiler-only additions to `libc-cflags` are not translated into another interpreter's options.

The callee's interface is part of the contract.
A prepared entry accepts selected policy; an opaque executable receives materialized arguments and environment values.
An executable pathname or `orig-cc` package path does not establish a prepared interface.
In particular, an arbitrary wrapped executable selected through a vendor tool override may itself apply additional policy; it is not interchangeable with the raw executable accepted by a prepared entry.
Known Nixpkgs producers supply the raw executable and prepared entry together.
A public compiler entry starts fresh and clears inherited bindings before running [wrapper hooks](../../../doc/stdenv/stdenv.chapter.md#compiler-linker-wrapper-hooks), including for compile-only calls; a hook's independent compiler invocation must select its own inputs.

### Legacy path

Every other compiler uses the shell scan in `cc-wrapper.sh` and the argument
scan in `ld-wrapper.sh`. Its semantics differ from the native path. For example,
purity and no-native filtering happen before hooks rather than on the driver's
expanded arguments.

## Decision: generic contract, native refinement

Role selection, executable-carried defaults and fresh/prepared delegation share
one policy transport. Native capability refines primary argument interpretation
and default-header lookup for the declared executables; other compilers retain
the legacy path. These paths still differ in argument grammar, purity filtering
and header suppression. Generic transport does not establish their equivalence.

### Link-mode policy

The compiler and linker have different argument interfaces.
The compiler renders main linker inputs for the primary operation and binds a
**link continuation** around the final raw driver. The record distinguishes
selected inputs from rendered arguments: if a linker job appears after primary
interpretation omitted rendering, the linker renders the selected inputs itself.
Compiler-only conditional channels remain governed by primary interpretation.
The linker wrapper performs the remaining work: capability-specific hardening,
trailing flags, emulation, RPATH discovery, build IDs and Darwin version handling.
Moving already rendered main flags after compiler-generated arguments would
change library resolution; skipping all linker processing would lose this work.

The native query reports primary driver option policy using GCC's existing spec
predicates after language and self-spec adjustment, or Clang's parsed argument
list after configuration loading. Ordinary caller response files use the native
grammar. This is a bounded part of primary interpretation: the query does not
construct jobs to inspect lowered linker arguments.

For link-policy rendering, the compiler scans BEFORE linker flags, the primary
policy marker (or legacy caller arguments), conditional compiler link flags and
main linker flags in that order. The compatibility scan recognizes literal
`-static` and `-static-pie` tokens; the last recognized token wins. The legacy
path uses its existing response-file expansion where available. This scan is
not an option parser and can mistake an option's operand for a mode.
A link continuation reuses the mode for which the compiler rendered its flags.
A fresh linker or an unrendered continuation applies the same literal scan to
its arguments. The linker does not reinterpret lowered `-Bstatic`/`-pie` modes
or remove a previously rendered loader or RPATH by matching its value.

Raw linker-policy rendering preserves known operand boundaries. Genuine
`-L/…` options retain their compiler-visible search channel; another option's
`-L/…` operand stays in the linker channel. Linker purity filtering and NVCC's
device-library projection use the same bounded option/operand table.
Compiler-visible `-L` paths precede the driver's built-in search paths;
forwarding every path only to the linker would change library precedence.
The table distinguishes declared BFD, gold and lld aliases; recognized raw
linker overrides can
select their flavor at the prepared linker boundary. It does not discover a
different linker selected inside opaque compiler transformations.

For a selected `static-pie` policy, raw policy RPATH filtering handles
`-rpath`/`--rpath`, including their `=value` forms, without consuming another
option's operand. Ambiguous `-R`/`--just-symbols` forms remain intact: BFD, gold
and lld differ, and a compiler-selected linker can differ from the declared
one before the raw linker boundary is reached. These flags retain the native
linker's symbol-import or RPATH semantics, including errors and RPATHs that can
make a glibc static PIE fail at startup. The wrapper does not inspect filesystem
state to reinterpret them. Opaque compiler channels and response files are not
translated into a complete linker argument stream.
Compiler link groups retain the historical, narrower filter for a literal
`-rpath` and its following token; they are not parsed as raw linker options.
For example, a compiler's `-include -Rheader.h` remains intact. An operand
spelled `-rpath` can still be consumed by the historical token filter.
Forwarded or aliased RPATHs in those opaque compiler groups are outside it.

#### Remaining link-policy limits

These limits are not repaired by the role/header changes:

- A mode introduced in a conditional `NIX_CFLAGS_LINK` response/configuration,
  an arbitrary link spec or a late hook can leave earlier loader/RPATH policy
  unchanged. Response files are not rewritten, and conditional channels do not
  recursively select primary policy.
- The scan does not determine final ELF program headers. Linker scripts and
  final emulation can change output layout or ABI independently of the selected
  wrapper. A script discarding `.interp` can leave RPATHs in a glibc static PIE,
  causing startup failure. The wrapper's selected loader need not match a
  different final emulation.
- Linkers differ when given a loader for a static executable: GNU ld normally
  omits it, while lld can retain it. A glibc static PIE with RPATHs can fail at
  startup. Policy selection, including automatic RPATH discovery, does not
  establish that every transformed link avoids these conditions.
- Explicit caller RPATHs and compiler/linker built-in defaults retain their own
  semantics. The wrapper does not trace their provenance or infer which equal
  argument belongs to a caller, a driver or a policy producer.
- Selecting a different or unwrapped linker does not supply its target ABI or
  alias grammar to the compiler wrapper. Constructor metadata is not a promise
  about arbitrary executable overrides.

### Native cooperation and future changes

Default-header replacement still requires native cooperation to retain frontend
suppression, native search groups, system-header classification and
`#include_next`. A GCC driver spec guarded by `nostdinc` misses forwarded
`-Wp,-nostdinc`; Clang's driver and frontend apply suppression at different
stages. Binding the original providers is separate from link-mode policy.
Native caller ownership also supports filtering through response expansion and
the supported forwarding streams; it does not establish general provenance
through arbitrary configurations, specs or plugins.

The [pre-rebase design](https://github.com/ConnorBaker/nixpkgs/blob/e58dcdca81f2830a83491cb3f1c9376924d07ddf/pkgs/build-support/wrapper-common/README.md)
records the withdrawn native linker prototype and its linker/version, multilib
and delegation failures. Compiler job observation and destructive final-link
reclassification are also excluded from this implementation. A future change
to linker defaults needs a separate producer/receiver contract that preserves
contribution order, public overrides, selected libc and unknown-tool fallback;
the present transport/header changes do not depend on that work.
