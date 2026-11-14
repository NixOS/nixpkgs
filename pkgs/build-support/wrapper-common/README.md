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
- The [generic contract](#decision-generic-contract-native-refinement) is
  accepted. Link-mode refinement uses compiler job observation and final classification
  in the ld-wrapper. Language and header-suppression interpretation still differ
  between native-capable and legacy drivers.

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

#### Primary interpretation and execution

For raw compilers advertising the native primary-argument interface, selection is acyclic.
First, the native driver interprets the unconditional BEFORE arguments, caller arguments, and compile arguments to select its personality; the GCC language driver supplies its compiled-in personality, while Clang also interprets `--driver-mode` and its native debug rewrite.
The wrapper selects the opaque caller C++ compile channel once, then asks that same native parser for the requested host operation and invocation-wide support-group applicability with that channel included.
Only then does it insert suppressible defaults and conditional link channels in their original positions.
A conditional channel or a late hook can still change the final native invocation, but cannot recursively select another wrapper policy.
For example, a C invocation with `NIX_CFLAGS_LINK=--driver-mode=g++` and `NIX_CXXSTDLIB_COMPILE=-c` has no consistent recursive choice: selecting the link channel would select C++ compilation, which would remove the link channel.
The primary interpretation therefore excludes the conditional link channel.
This describes the requested host operation, not successful execution or every device-packaging job; an archive or CUDA fatbin is not a host image link.

The primary request must be parseable before conditional default/link fragments and the late hook are inserted.
An explicit caller frontend entry bypasses compiler/linker argument contributions (the selected SDK environment is retained); introducing a frontend entry through primary policy is rejected rather than discarding that policy.
Consequently, supplying an option's missing operand only through such a fragment is outside this interface; options and operands must be supplied together.
The wrapper retains raw caller arguments through hooks and sends ordered argument groups to the native driver for both primary interpretation and final execution.
Clang first checks the caller's standalone native frontend entry, including caller response files, without reading policy response files or applying their quoting selectors.
For an ordinary driver entry it interprets the original groups using the combined native response-file grammar; selected C++ compile arguments participate in the subsequent primary interpretation.
Final execution reads the raw groups again, expands response files natively, and positions suffix arguments before a parser-recognized caller `--` boundary.
These are separate interpretation epochs, not a promise to read each response file once or freeze its contents across hooks.
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

Accepted direction (2026-10-13); the current legacy path above has not yet been replaced:

1. **The contract is generic.** It is defined by mechanisms that every GCC- or
   Clang-family driver already provides, including vendor forks, prebuilt
   releases, older versions and the bootstrap compiler.
2. **Native capability is a refinement.** It may add exactness for the cases
   listed under [Limits](#limits-of-the-generic-tier), but ordinary invocations
   must produce the same result with or without it. A compiler override must not
   silently change wrapper semantics.
3. **The shell scan should be a last resort**, retained only for compilers that
   are neither GCC- nor Clang-like.

Rationale:

- The constraints above make patched compilers the exception rather than the
  rule.
- Today an override silently switches between two semantic regimes.
- The patches span GCC 14–16, Clang 19–23 and Swift's LLVM fork, so each
  release needs a rebase.

### Generic mechanisms

#### Driver observation

The implemented generic refinement observes GCC/Clang link jobs before rendering
link-mode policy; it does not replace conditional channels with specs or config
files. Native queries suppress caller output effects, while legacy drivers use
a bounded `-###` dry run. This normally costs one additional driver execution
and parses informal job output; the mechanisms and limits are described below.

#### Link-mode policy at the linker

The compiler and linker have different argument interfaces.
The compiler renders main linker inputs for the primary operation and binds a
**link continuation** around the final raw driver. The record distinguishes
selected inputs from rendered arguments: if a linker job appears after primary
interpretation omitted rendering, the linker renders the selected inputs itself.
Compiler-only conditional channels remain governed by primary interpretation.
The linker wrapper retains that policy and performs the remaining work: capability-specific hardening, trailing flags, emulation, RPATH discovery, build IDs, and Darwin version handling.
For an ordinary link, moving already rendered main flags after compiler-generated arguments would change library resolution; skipping all linker processing would lose the remaining policy.

By the time the linker runs, the driver has translated the link mode, whichever
channel supplied it.

- For `-static-pie`, Clang passes `-static -pie --no-dynamic-linker -z text`.
- GCC 15.2's built-in spec passes `-Bstatic -pie --no-dynamic-linker -z text`.
- For `-static`, Clang passes `-static`, and GCC 15.3 and 16.2 for
  `aarch64-unknown-linux-gnu` pass `-Bstatic`.

The common static-PIE signal is `-pie` together with `--no-dynamic-linker`.
`-Bstatic` is a per-library toggle, not a property of the entire output. The
classifier tracks its push/pop state and preceding potentially dynamic library
inputs; a final `-Bstatic` does not erase a DSO already selected earlier. It
uses an explicit linker option/operand table and retains the order of output-mode
and loader selections. The table distinguishes GNU and lld aliases; it does not
replace either linker's parser.

Compiler observation and execution share raw linker-policy rendering. Genuine
`-L/…` options retain their compiler-visible search channel (including GCC specs
matching); other options' operands stay in the linker channel. Linker purity
filtering and NVCC's device-library projection also preserve these known operand
boundaries. The linker flavor comes from each wrapper's constructor, with
recognized executable overrides refined at invocation time.
Selector scans preserve known driver and linker operand boundaries: an output
filename such as `-fuse-ld=lld` does not select a different linker.

**Accepted inference limit:** a dynamic-mode `-lfoo` followed by `-Bstatic` may
have selected a DSO, only an archive, or an unused as-needed library. Without
resolving linker searches/scripts or executing the linker, the wrapper retains
dynamic policy conservatively. GNU ld ignores a loader on an actual static
executable; lld can retain it in this ambiguous case. Explicit earlier DSOs keep
the loader, while explicit `.a` inputs and `-l:*.a` do not create this ambiguity.

The linkers agree on precedence but not on static output:

- In both lld (`getDynamicLinker`) and GNU ld (`parse_args` in `ld/lexsup.c`),
  the last of `-dynamic-linker` and `--no-dynamic-linker` wins.
- Given a loader, GNU ld omits it from a static executable, but lld records it,
  and the executable crashes.
- A glibc static PIE with any RPATH crashes at startup. In a static non-PIE
  executable an RPATH has no effect.
- Neither linker records a loader in a shared library.

A loader the compiler wrapper passes through `-Wl` reaches the linker after the
driver's own `--no-dynamic-linker`, so it wins; that is the static-PIE defect.
The RPATH entries it renders from `NIX_LDFLAGS` have the same problem, and
stdenv's `setup.sh` adds `-rpath $out/lib` there in every build unless
`NIX_NO_SELF_RPATH` is set.

**Implemented in the ld-wrapper.** The ld-wrapper classifies the output from
the ordered arguments it will pass, ignoring the loader the compiler wrapper
rendered when inferring the mode. This includes fresh BEFORE/MAIN policy and
trailing AFTER policy in their execution positions.

- On a link continuation, it removes that loader from a static executable, and
  also the rendered BEFORE/MAIN policy RPATH entries from a static PIE. It
  matches BEFORE contributions from the front and MAIN contributions from the
  back, preserving the order of equal caller RPATHs. Alias interpretation
  follows the declared linker: GNU `-R`/`--just-symbols` denote runtime paths
  for directories or nonexistent paths, preserving existing symbol files; lld
  treats `-R` as RPATH even for existing files, and long `--just-symbols` as
  symbol-file input, retaining missing-file errors. Known `ld.lld`, `ld.bfd`
  and `ld.gold` overrides select their declared flavor. Unknown explicit linker
  interfaces skip ambiguous aliases while canonical `-rpath`/`--rpath` policy
  remains handled. Option-shaped operands remain operands.
- A fresh invocation, or a continuation without rendered main flags, renders its
  selected policy for the classified mode.
- The compiler wrapper's guess (`wrapper_NIX_LINK_TYPE`) now only records what
  the compiler wrapper rendered.

**Compiler-side observation.** Before rendering the loader and RPATHs, the
wrapper obtains parsed GCC/Clang link jobs, including modes supplied through
specs, configurations and response files. This also covers an unwrapped linker.
Native-capable drivers use the FD-v3 query with private temporary outputs and
optional `NIX_CC_PRIMARY_SHOW_JOBS=1`; it suppresses caller output effects and
prints jobs when safe host-only observation is available. Clang declines job
construction for CUDA/HIP sources and offload, OpenMP or SYCL requests to avoid
discovery helpers, retaining primary metadata and the compatibility mode scan.
Older FD-v3 producers without job reporting also retain that scan.

Legacy Clang uses `-###`, redirecting its compilation-database and serialized
diagnostic outputs into the private observation directory, including options
hidden in configurations; nonempty `CCC_OVERRIDE_OPTIONS` disables observation
because it can rewrite away `-###`. Legacy GNU skips observation for known immediate
logging/truncation effects and opaque response-file inputs. Custom specs can
have opaque effects which that legacy path cannot sandbox or guarantee equivalent.

The observer decodes complete quoted records, including multiline GCC option
summaries, without evaluating shell text. For `collect2`, selector recognition
follows the reported GCC generation, assuming modern behavior if unrecognized,
while mode classification omits its consumed private
options; its operand boundaries differ from the final linker's.
It recognizes link jobs and applies `checkLinkerLinkType` to their lowered arguments. If native
linker discovery changes the MAIN policy's compiler/linker translation, it
observes that rendering once more and retains its translation choice for
execution. This is bounded refinement, not fixed-point iteration: specs can
make linker selection depend on compiler-visible search paths. For static
PIE, compiler policy filtering also removes visible forwarded RPATH options in
`-Wl` and `-Xlinker` forms while retaining unrelated operands and explicit caller arguments.

**Limits.** Unknown drivers, opaque launchers, unsuccessful observations and
unrecognized job formats retain the compatibility mode scan. Late wrapper hooks
run after observation and can still change the mode. A wrapped linker sees the
resulting arguments; an unwrapped linker retains the previously rendered policy.
This correction does not restore contributions filtered before a hook: changing
static PIE into another mode requires the hook to supply any newly needed flags.
An RPATH hidden inside an opaque `NIX_CFLAGS_LINK` `@policy` response file can
survive even when observation identifies static PIE: the shell sanitizer cannot
rewrite the raw file using the native response grammar, and the receiving linker
tracks rendered `NIX_LDFLAGS` contributions rather than that compiler-channel
file. This limit applies with a wrapped linker too. Response files are not
rewritten, and explicit caller RPATHs remain the caller's responsibility.
Observation refines link mode only; it does not replace legacy
language/header-suppression parsing
or prove native/legacy equivalence.

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
- **Per-argument provenance through native response-file expansion.** Filtering
  expanded caller arguments needs native ownership information. Current RPATH
  cleanup instead matches known rendered policy contributions; it does not track
  arbitrary provenance through opaque response files or driver transformations.

### Consequences for in-progress work

- **The native linker prototype was withdrawn.** The
  [pre-rebase design](https://github.com/ConnorBaker/nixpkgs/blob/e58dcdca81f2830a83491cb3f1c9376924d07ddf/pkgs/build-support/wrapper-common/README.md)
  records its linker/version, multilib and delegation failures. Its all-job origin
  labels were withdrawn too; current filtering preserves ownership only in the
  native streams described above.
- **The legacy shell classification should be replaced** for GCC- and
  Clang-family drivers by driver-interpreted channels, with or without `-###`.
- **The native and generic paths must agree on ordinary inputs.** Known
  divergence: where purity and no-native filtering apply.

### Open questions

- Whether driver-interpreted channels can replace legacy `-###` observation.
  Nixpkgs' Clang has no driver-conditioned loader, and per-invocation RPATH
  entries do not fit a packaged specs file; the current implementation uses
  observation plus the wrapped-linker boundary.
- How a constructor identifies a GCC- or Clang-family driver. The existing
  `isGNU` and `isClang` metadata covers Nixpkgs-built compilers; vendor forks
  need an explicit declaration.
- Whether each role should get its own executable, so that `CC_FOR_BUILD`
  selects BUILD policy without relying on the environment.
- Darwin (ld64) and MinGW, where the native frames' POSIX descriptors are not
  available.
