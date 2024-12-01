# Cross-compilation {#chap-cross}

## Introduction {#sec-cross-intro}

"Cross-compilation" means compiling a program on one machine for another type of machine. For example, a typical use of cross-compilation is to compile programs for embedded devices. These devices often don't have the computing power and memory to compile their own programs. One might think that cross-compilation is a fairly niche concern. However, there are significant advantages to rigorously distinguishing between build-time and run-time environments! Significant, because the benefits apply even when one is developing and deploying on the same machine. Nixpkgs is increasingly adopting the opinion that packages should be written with cross-compilation in mind, and Nixpkgs should evaluate in a similar way (by minimizing cross-compilation-specific special cases) whether or not one is cross-compiling.

This chapter will be organized in three parts. First, it will describe the basics of how to package software in a way that supports cross-compilation. Second, it will describe how to use Nixpkgs when cross-compiling. Third, it will describe the internal infrastructure supporting cross-compilation.

## Packaging in a cross-friendly manner {#sec-cross-packaging}

### Platform parameters {#ssec-cross-platform-parameters}

Nixpkgs follows the [conventions of GNU autoconf](https://gcc.gnu.org/onlinedocs/gccint/Configure-Terms.html). We distinguish between 3 types of platforms when building a derivation: _build_, _host_, and _target_. In summary, _build_ is the platform on which a package is being built, _host_ is the platform on which it will run. The third attribute, _target_, is relevant only for certain specific compilers and build tools.

In Nixpkgs, these three platforms are defined as attribute sets under the names `buildPlatform`, `hostPlatform`, and `targetPlatform`. They are always defined as attributes in the standard environment. That means one can access them like:

```nix
{ stdenv, fooDep, barDep, ... }: {
  # ...stdenv.buildPlatform...
}
```

`buildPlatform`

: The "build platform" is the platform on which a package is built. Once someone has a built package, or pre-built binary package, the build platform should not matter and can be ignored.

`hostPlatform`

: The "host platform" is the platform on which a package will be run. This is the simplest platform to understand, but also the one with the worst name.

`targetPlatform`

: The "target platform" attribute is, unlike the other two attributes, not actually fundamental to the process of building software. Instead, it is only relevant for compatibility with building certain specific compilers and build tools. It can be safely ignored for all other packages.

: The build process of certain compilers is written in such a way that the compiler resulting from a single build can itself only produce binaries for a single platform. The task of specifying this single "target platform" is thus pushed to build time of the compiler. The root cause of this is that the compiler (which will be run on the host) and the standard library/runtime (which will be run on the target) are built by a single build process.

: There is no fundamental need to think about a single target ahead of time like this. If the tool supports modular or pluggable backends, both the need to specify the target at build time and the constraint of having only a single target disappear. An example of such a tool is LLVM.

: Although the existence of a "target platform" is arguably a historical mistake, it is a common one: examples of tools that suffer from it are GCC, Binutils, GHC and Autoconf. Nixpkgs tries to avoid sharing in the mistake where possible. Still, because the concept of a target platform is so ingrained, it is best to support it as is.

The exact schema these fields follow is a bit ill-defined due to a long and convoluted evolution, but this is slowly being cleaned up. You can see examples of ones used in practice in `lib.systems.examples`; note how they are not all very consistent. For now, here are few fields can count on them containing:

`system`

: This is a two-component shorthand for the platform. Examples of this would be "x86_64-darwin" and "i686-linux"; see `lib.systems.doubles` for more. The first component corresponds to the CPU architecture of the platform and the second to the operating system of the platform (`[cpu]-[os]`). This format has built-in support in Nix, such as the `builtins.currentSystem` impure string.

`config`

: This is a 3- or 4- component shorthand for the platform. Examples of this would be `x86_64-unknown-linux-gnu` and `aarch64-apple-darwin14`. This is a standard format called the "LLVM target triple", as they are pioneered by LLVM. In the 4-part form, this corresponds to `[cpu]-[vendor]-[os]-[abi]`. This format is strictly more informative than the "Nix host double", as the previous format could analogously be termed. This needs a better name than `config`!

`parsed`

: This is a Nix representation of a parsed LLVM target triple with white-listed components. This can be specified directly, or actually parsed from the `config`. See `lib.systems.parse` for the exact representation.

`libc`

: This is a string identifying the standard C library used. Valid identifiers include "glibc" for GNU libc, "libSystem" for Darwin's Libsystem, and "uclibc" for µClibc. It should probably be refactored to use the module system, like `parse`.

`is*`

: These predicates are defined in `lib.systems.inspect`, and slapped onto every platform. They are superior to the ones in `stdenv` as they force the user to be explicit about which platform they are inspecting. Please use these instead of those.

`platform`

: This is, quite frankly, a dumping ground of ad-hoc settings (it's an attribute set). See `lib.systems.platforms` for examples—there's hopefully one in there that will work verbatim for each platform that is working. Please help us triage these flags and give them better homes!

### Theory of dependency categorization {#ssec-cross-dependency-categorization}

::: {.note}
This is a rather philosophical description that isn't very Nixpkgs-specific. For an overview of all the relevant attributes given to `mkDerivation`, see [](#ssec-stdenv-dependencies). For a description of how everything is implemented, see [](#ssec-cross-dependency-implementation).
:::

In this section we explore the relationship between both runtime and build-time dependencies and the 3 Autoconf platforms.

A run time dependency between two packages requires that their host platforms match. This is directly implied by the meaning of "host platform" and "runtime dependency": The package dependency exists while both packages are running on a single host platform.

A build time dependency, however, has a shift in platforms between the depending package and the depended-on package. "build time dependency" means that to build the depending package we need to be able to run the depended-on's package. The depending package's build platform is therefore equal to the depended-on package's host platform.

If both the dependency and depending packages aren't compilers or other machine-code-producing tools, we're done. And indeed `buildInputs` and `nativeBuildInputs` have covered these simpler cases for many years. But if the dependency does produce machine code, we might need to worry about its target platform too. In principle, that target platform might be any of the depending package's build, host, or target platforms, but we prohibit dependencies from a "later" platform to an earlier platform to limit confusion because we've never seen a legitimate use for them.

Finally, if the depending package is a compiler or other machine-code-producing tool, it might need dependencies that run at "emit time". This is for compilers that (regrettably) insist on being built together with their source languages' standard libraries. Assuming build != host != target, a run-time dependency of the standard library cannot be run at the compiler's build time or run time, but only at the run time of code emitted by the compiler.

Putting this all together, that means that we have dependency types of the form "X→ E", which means that the dependency executes on X and emits code for E; each of X and E can be `build`, `host`, or `target`, and E can be `*` to indicate that the dependency is not a compiler-like package.

Dependency types describe the relationships that a package has with each of its transitive dependencies.  You could think of attaching one or more dependency types to each of the formal parameters at the top of a package's `.nix` file, as well as to all of *their* formal parameters, and so on.   Triples like `(foo, bar, baz)`, on the other hand, are a property of an instantiated derivation -- you could would attach a triple `(mips-linux, mips-linux, sparc-solaris)` to a `.drv` file in `/nix/store`.

Only nine dependency types matter in practice:

#### Possible dependency types {#possible-dependency-types}

| Dependency type | Dependency’s host platform | Dependency’s target platform |
|-----------------|----------------------------|------------------------------|
| build → *       | build                      | (none)                       |
| build → build   | build                      | build                        |
| build → host    | build                      | host                         |
| build → target  | build                      | target                       |
| host → *        | host                       | (none)                       |
| host → host     | host                       | host                         |
| host → target   | host                       | target                       |
| target → *      | target                     | (none)                       |
| target → target | target                     | target                       |

Let's use `g++` as an example to make this table clearer.  `g++` is a C++ compiler written in C.  Suppose we are building `g++` with a `(build, host, target)` platform triple of `(foo, bar, baz)`.  This means we are using a `foo`-machine to build a copy of `g++` which will run on a `bar`-machine and emit binaries for the `baz`-machine.

* `g++` links against the host platform's `glibc` C library, which is a "host→ *" dependency with a triple of `(bar, bar, *)`.  Since it is a library, not a compiler, it has no "target".

* Since `g++` is written in C, the `gcc` compiler used to compile it is a "build→ host" dependency of `g++` with a triple of `(foo, foo, bar)`.  This compiler runs on the build platform and emits code for the host platform.

* `gcc` links against the build platform's `glibc` C library, which is a "build→ *" dependency with a triple of `(foo, foo, *)`.  Since it is a library, not a compiler, it has no "target".

* This `gcc` is itself compiled by an *earlier* copy of `gcc`.  This earlier copy of `gcc` is a "build→ build" dependency of `g++` with a triple of `(foo, foo, foo)`.  This "early `gcc`" runs on the build platform and emits code for the build platform.

* `g++` is bundled with `libgcc`, which includes a collection of target-machine routines for exception handling and
software floating point emulation.  `libgcc` would be a "target→ *" dependency with triple `(foo, baz, *)`, because it consists of machine code which gets linked against the output of the compiler that we are building.  It is a library, not a compiler, so it has no target of its own.

* `libgcc` is written in C and compiled with `gcc`.  The `gcc` that compiles it will be a "build→ target" dependency with triple `(foo, foo, baz)`.  It gets compiled *and run* at `g++`-build-time (on platform `foo`), but must emit code for the `baz`-platform.

* `g++` allows inline assembler code, so it depends on access to a copy of the `gas` assembler.  This would be a "host→ target" dependency with triple `(foo, bar, baz)`.

* `g++` (and `gcc`) include a library `libgccjit.so`, which wrap the compiler in a library to create a just-in-time compiler.  In nixpkgs, this library is in the `libgccjit` package; if C++ required that programs have access to a JIT, `g++` would need to add a "target→ target" dependency for `libgccjit` with triple `(foo, baz, baz)`.  This would ensure that the compiler ships with a copy of `libgccjit` which both executes on and generates code for the `baz`-platform.

* If `g++` itself linked against `libgccjit.so` (for example, to allow compile-time-evaluated C++ expressions), then the `libgccjit` package used to provide this functionality would be a "host→ host" dependency of `g++`: it is code which runs on the `host` and emits code for execution on the `host`.

### Cross packaging cookbook {#ssec-cross-cookbook}

Some frequently encountered problems when packaging for cross-compilation should be answered here. Ideally, the information above is exhaustive, so this section cannot provide any new information, but it is ludicrous and cruel to expect everyone to spend effort working through the interaction of many features just to figure out the same answer to the same common problem. Feel free to add to this list!

#### My package fails to find a binutils command (`cc`/`ar`/`ld` etc.) {#cross-qa-fails-to-find-binutils}
Many packages assume that an unprefixed binutils (`cc`/`ar`/`ld` etc.) is available, but Nix doesn't provide one. It only provides a prefixed one, just as it only does for all the other binutils programs. It may be necessary to patch the package to fix the build system to use a prefix. For instance, instead of `cc`, use `${stdenv.cc.targetPrefix}cc`.

```nix
{
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
}
```

#### How do I avoid compiling a GCC cross-compiler from source? {#cross-qa-avoid-compiling-gcc-cross-compiler}
On less powerful machines, it can be inconvenient to cross-compile a package only to find out that GCC has to be compiled from source, which could take up to several hours. Nixpkgs maintains a limited [cross-related jobset on Hydra](https://hydra.nixos.org/jobset/nixpkgs/cross-trunk), which tests cross-compilation to various platforms from build platforms "x86\_64-darwin", "x86\_64-linux", and "aarch64-linux".  See `pkgs/top-level/release-cross.nix` for the full list of target platforms and packages.  For instance, the following invocation fetches the pre-built cross-compiled GCC for `armv6l-unknown-linux-gnueabihf` and builds GNU Hello from source.

```ShellSession
$ nix-build '<nixpkgs>' -A pkgsCross.raspberryPi.hello
```

#### What if my package’s build system needs to build a C program to be run under the build environment? {#cross-qa-build-c-program-in-build-environment}

Add the following to your `mkDerivation` invocation.

```nix
{
  depsBuildBuild = [ buildPackages.stdenv.cc ];
}
```

#### My package’s testsuite needs to run host platform code. {#cross-testsuite-runs-host-code}

Add the following to your `mkDerivation` invocation.

```nix
{
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
}
```

#### Package using Meson needs to run binaries for the host platform during build. {#cross-meson-runs-host-code}

Add `mesonEmulatorHook` to `nativeBuildInputs` conditionally on if the target binaries can be executed.

e.g.

```nix
{
  nativeBuildInputs = [
    meson
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];
}
```

Example of an error which this fixes.

`[Errno 8] Exec format error: './gdk3-scan'`

#### Using `-static` outside a `isStatic` platform. {#cross-static-on-non-static-platform}

Add `stdenv.cc.libc.static` (static output of glibc) to `buildInputs` conditionally on if `hostPlatform` uses `glibc`.


e.g.

```nix
{
  buildInputs = lib.optionals (stdenv.hostPlatform.libc == "glibc") [ stdenv.cc.libc.static ];
}
```

Examples of errors which this fixes.

`cannot find -lm: No such file or directory`

`cannot find -lc: No such file or directory`

::: {.note}
At the time of writing it is assumed the issue only happens on `glibc` because it splits the static libraries in to a different output.

::: {.note}
You may want to look in to using `stdenvAdapters.makeStatic` or `pkgsStatic` or a `isStatic = true` platform.

## Cross-building packages {#sec-cross-usage}

Nixpkgs can be instantiated with `localSystem` alone, in which case there is no cross-compiling and everything is built by and for that system, or also with `crossSystem`, in which case packages run on the latter, but all building happens on the former. Both parameters take the same schema as the 3 (build, host, and target) platforms defined in the previous section. As mentioned above, `lib.systems.examples` has some platforms which are used as arguments for these parameters in practice. You can use them programmatically, or on the command line:

```ShellSession
$ nix-build '<nixpkgs>' --arg crossSystem '(import <nixpkgs/lib>).systems.examples.fooBarBaz' -A whatever
```

::: {.note}
Eventually we would like to make these platform examples an unnecessary convenience so that

```ShellSession
$ nix-build '<nixpkgs>' --arg crossSystem '{ config = "<arch>-<os>-<vendor>-<abi>"; }' -A whatever
```

works in the vast majority of cases. The problem today is dependencies on other sorts of configuration which aren't given proper defaults. We rely on the examples to crudely to set those configuration parameters in some vaguely sane manner on the users behalf. Issue [\#34274](https://github.com/NixOS/nixpkgs/issues/34274) tracks this inconvenience along with its root cause in crufty configuration options.
:::

While one is free to pass both parameters in full, there's a lot of logic to fill in missing fields. As discussed in the previous section, only one of `system`, `config`, and `parsed` is needed to infer the other two. Additionally, `libc` will be inferred from `parse`. Finally, `localSystem.system` is also _impurely_ inferred based on the platform evaluation occurs. This means it is often not necessary to pass `localSystem` at all, as in the command-line example in the previous paragraph.

::: {.note}
Many sources (manual, wiki, etc) probably mention passing `system`, `platform`, along with the optional `crossSystem` to Nixpkgs: `import <nixpkgs> { system = ..; platform = ..; crossSystem = ..; }`. Passing those two instead of `localSystem` is still supported for compatibility, but is discouraged. Indeed, much of the inference we do for these parameters is motivated by compatibility as much as convenience.
:::

One would think that `localSystem` and `crossSystem` overlap horribly with the three `*Platforms` (`buildPlatform`, `hostPlatform,` and `targetPlatform`; see `stage.nix` or the manual). Actually, those identifiers are purposefully not used here to draw a subtle but important distinction: While the granularity of having 3 platforms is necessary to properly *build* packages, it is overkill for specifying the user's *intent* when making a build plan or package set. A simple "build vs deploy" dichotomy is adequate: the sliding window principle described in the previous section shows how to interpolate between the these two "end points" to get the 3 platform triple for each bootstrapping stage. That means for any package a given package set, even those not bound on the top level but only reachable via dependencies or `buildPackages`, the three platforms will be defined as one of `localSystem` or `crossSystem`, with the former replacing the latter as one traverses build-time dependencies. A last simple difference is that `crossSystem` should be null when one doesn't want to cross-compile, while the `*Platform`s are always non-null. `localSystem` is always non-null.

## Cross-compilation infrastructure {#sec-cross-infra}

### Implementation of dependencies {#ssec-cross-dependency-implementation}

The categories of dependencies developed in [](#ssec-cross-dependency-categorization) are specified as lists of derivations given to `mkDerivation`, as documented in [](#ssec-stdenv-dependencies). In short, each list of dependencies for "host → target" is called `deps<host><target>` (where `host`, and `target` values are either `build`, `host`, or `target`), with exceptions for backwards compatibility that `depsBuildHost` is instead called `nativeBuildInputs` and `depsHostTarget` is instead called `buildInputs`. Nixpkgs is now structured so that each `deps<host><target>` is automatically taken from `pkgs<host><target>`. (These `pkgs<host><target>`s are quite new, so there is no special case for `nativeBuildInputs` and `buildInputs`.) For example, `pkgsBuildHost.gcc` should be used at build-time, while `pkgsHostTarget.gcc` should be used at run-time.

Now, for most of Nixpkgs's history, there were no `pkgs<host><target>` attributes, and most packages have not been refactored to use it explicitly. Prior to those, there were just `buildPackages`, `pkgs`, and `targetPackages`. Those are now redefined as aliases to `pkgsBuildHost`, `pkgsHostTarget`, and `pkgsTargetTarget`. It is acceptable, even recommended, to use them for libraries to show that the host platform is irrelevant.

But before that, there was just `pkgs`, even though both `buildInputs` and `nativeBuildInputs` existed. \[Cross barely worked, and those were implemented with some hacks on `mkDerivation` to override dependencies.\] What this means is the vast majority of packages do not use any explicit package set to populate their dependencies, just using whatever `callPackage` gives them even if they do correctly sort their dependencies into the multiple lists described above. And indeed, asking that users both sort their dependencies, _and_ take them from the right attribute set, is both too onerous and redundant, so the recommended approach (for now) is to continue just categorizing by list and not using an explicit package set.

To make this work, we "splice" together the six `pkgsFooBar` package sets and have `callPackage` actually take its arguments from that. This is currently implemented in `pkgs/top-level/splice.nix`. `mkDerivation` then, for each dependency attribute, pulls the right derivation out from the splice. This splicing can be skipped when not cross-compiling as the package sets are the same, but still is a bit slow for cross-compiling. We'd like to do something better, but haven't come up with anything yet.

### Bootstrapping {#ssec-bootstrapping}

Each of the package sets described above come from a single bootstrapping stage. While `pkgs/top-level/default.nix`, coordinates the composition of stages at a high level, `pkgs/top-level/stage.nix` "ties the knot" (creates the fixed point) of each stage. The package sets are defined per-stage however, so they can be thought of as edges between stages (the nodes) in a graph. Compositions like `pkgsBuildTarget.targetPackages` can be thought of as paths to this graph.

While there are many package sets, and thus many edges, the stages can also be arranged in a linear chain. In other words, many of the edges are redundant as far as connectivity is concerned. This hinges on the type of bootstrapping we do. Currently for cross it is:

1.  `(native, native, native)`

2.  `(native, native, foreign)`

3.  `(native, foreign, foreign)`

In each stage, `pkgsBuildHost` refers to the previous stage, `pkgsBuildBuild` refers to the one before that, and `pkgsHostTarget` refers to the current one, and `pkgsTargetTarget` refers to the next one. When there is no previous or next stage, they instead refer to the current stage. Note how all the invariants regarding the mapping between dependency and depending packages' build host and target platforms are preserved. `pkgsBuildTarget` and `pkgsHostHost` are more complex in that the stage fitting the requirements isn't always a fixed chain of "prevs" and "nexts" away (modulo the "saturating" self-references at the ends). We just special case each instead. All the primary edges are implemented is in `pkgs/stdenv/booter.nix`, and secondarily aliases in `pkgs/top-level/stage.nix`.

::: {.note}
The native stages are bootstrapped in legacy ways that predate the current cross implementation. This is why the bootstrapping stages leading up to the final stages are ignored in the previous paragraph.
:::

If one looks at the 3 platform triples, one can see that they overlap such that one could put them together into a chain like:
```
(native, native, native, foreign, foreign)
```

If one imagines the saturating self references at the end being replaced with infinite stages, and then overlays those platform triples, one ends up with the infinite tuple:
```
(native..., native, native, native, foreign, foreign, foreign...)
```
One can then imagine any sequence of platforms such that there are bootstrap stages with their 3 platforms determined by "sliding a window" that is the 3 tuple through the sequence. This was the original model for bootstrapping. Without a target platform (assume a better world where all compilers are multi-target and all standard libraries are built in their own derivation), this is sufficient. Conversely if one wishes to cross compile "faster", with a "Canadian Cross" bootstrapping stage where `build != host != target`, more bootstrapping stages are needed since no sliding window provides the pesky `pkgsBuildTarget` package set since it skips the Canadian cross stage's "host".


::: {.note}
It is much better to refer to `buildPackages` than `targetPackages`, or more broadly package sets that do not mention “target”. There are three reasons for this.

First, it is because bootstrapping stages do not have a unique `targetPackages`. For example a `(x86-linux, x86-linux, arm-linux)` and `(x86-linux, x86-linux, x86-windows)` package set both have a `(x86-linux, x86-linux, x86-linux)` package set. Because there is no canonical `targetPackages` for such a native (`build == host == target`) package set, we set their `targetPackages`

Second, it is because this is a frequent source of hard-to-follow "infinite recursions" / cycles. When only package sets that don't mention target are used, the package set forms a directed acyclic graph. This means that all cycles that exist are confined to one stage. This means they are a lot smaller, and easier to follow in the code or a backtrace. It also means they are present in native and cross builds alike, and so more likely to be caught by CI and other users.

Thirdly, it is because everything target-mentioning only exists to accommodate compilers with lousy build systems that insist on the compiler itself and standard library being built together. Of course that is bad because bigger derivations means longer rebuilds. It is also problematic because it tends to make the standard libraries less like other libraries than they could be, complicating code and build systems alike. Because of the other problems, and because of these innate disadvantages, compilers ought to be packaged another way where possible.
:::

::: {.note}
If one explores Nixpkgs, they will see derivations with names like `gccCross`. Such `*Cross` derivations is a holdover from before we properly distinguished between the host and target platforms—the derivation with “Cross” in the name covered the `build = host != target` case, while the other covered the `host = target`, with build platform the same or not based on whether one was using its `.__spliced.buildHost` or `.__spliced.hostTarget`.
:::
