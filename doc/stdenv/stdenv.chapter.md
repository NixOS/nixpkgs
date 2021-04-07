# The Standard Environment {#chap-stdenv}

The standard build environment in the Nix Packages collection provides an environment for building Unix packages that does a lot of common build tasks automatically. In fact, for Unix packages that use the standard `./configure; make; make install` build interface, you don’t need to write a build script at all; the standard environment does everything automatically. If `stdenv` doesn’t do what you need automatically, you can easily customise or override the various build phases.

## Using `stdenv` {#sec-using-stdenv}

To build a package with the standard environment, you use the function `stdenv.mkDerivation`, instead of the primitive built-in function `derivation`, e.g.

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  src = fetchurl {
    url = "http://example.org/libfoo-1.2.3.tar.bz2";
    sha256 = "0x2g1jqygyr5wiwg4ma1nd7w4ydpy82z9gkcv8vh2v8dn3y58v5m";
  };
}
```

(`stdenv` needs to be in scope, so if you write this in a separate Nix expression from `pkgs/all-packages.nix`, you need to pass it as a function argument.) Specifying a `name` and a `src` is the absolute minimum Nix requires. For convenience, you can also use `pname` and `version` attributes and `mkDerivation` will automatically set `name` to `"${pname}-${version}"` by default. Since [RFC 0035](https://github.com/NixOS/rfcs/pull/35), this is preferred for packages in Nixpkgs, as it allows us to reuse the version easily:

```nix
stdenv.mkDerivation rec {
  pname = "libfoo";
  version = "1.2.3";
  src = fetchurl {
    url = "http://example.org/libfoo-source-${version}.tar.bz2";
    sha256 = "0x2g1jqygyr5wiwg4ma1nd7w4ydpy82z9gkcv8vh2v8dn3y58v5m";
  };
}
```

Many packages have dependencies that are not provided in the standard environment. It’s usually sufficient to specify those dependencies in the `buildInputs` attribute:

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  ...
  buildInputs = [libbar perl ncurses];
}
```

This attribute ensures that the `bin` subdirectories of these packages appear in the `PATH` environment variable during the build, that their `include` subdirectories are searched by the C compiler, and so on. (See <xref linkend="ssec-setup-hooks" /> for details.)

Often it is necessary to override or modify some aspect of the build. To make this easier, the standard environment breaks the package build into a number of *phases*, all of which can be overridden or modified individually: unpacking the sources, applying patches, configuring, building, and installing. (There are some others; see <xref linkend="sec-stdenv-phases" />.) For instance, a package that doesn’t supply a makefile but instead has to be compiled "manually" could be handled like this:

```nix
stdenv.mkDerivation {
  name = "fnord-4.5";
  ...
  buildPhase = ''
    gcc foo.c -o foo
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp foo $out/bin
  '';
}
```

(Note the use of `''`-style string literals, which are very convenient for large multi-line script fragments because they don’t need escaping of `"` and `\`, and because indentation is intelligently removed.)

There are many other attributes to customise the build. These are listed in <xref linkend="ssec-stdenv-attributes" />.

While the standard environment provides a generic builder, you can still supply your own build script:

```nix
stdenv.mkDerivation {
  name = "libfoo-1.2.3";
  ...
  builder = ./builder.sh;
}
```

where the builder can do anything it wants, but typically starts with

```bash
source $stdenv/setup
```

to let `stdenv` set up the environment (e.g., process the `buildInputs`). If you want, you can still use `stdenv`’s generic builder:

```bash
source $stdenv/setup

buildPhase() {
  echo "... this is my custom build phase ..."
  gcc foo.c -o foo
}

installPhase() {
  mkdir -p $out/bin
  cp foo $out/bin
}

genericBuild
```

## Tools provided by `stdenv` {#sec-tools-of-stdenv}

The standard environment provides the following packages:

- The GNU C Compiler, configured with C and C++ support.
- GNU coreutils (contains a few dozen standard Unix commands).
- GNU findutils (contains `find`).
- GNU diffutils (contains `diff`, `cmp`).
- GNU `sed`.
- GNU `grep`.
- GNU `awk`.
- GNU `tar`.
- `gzip`, `bzip2` and `xz`.
- GNU Make.
- Bash. This is the shell used for all builders in the Nix Packages collection. Not using `/bin/sh` removes a large source of portability problems.
- The `patch` command.

On Linux, `stdenv` also includes the `patchelf` utility.

## Specifying dependencies {#ssec-stdenv-dependencies}

As described in the Nix manual, almost any `*.drv` store path in a derivation’s attribute set will induce a dependency on that derivation. `mkDerivation`, however, takes a few attributes intended to, between them, include all the dependencies of a package. This is done both for structure and consistency, but also so that certain other setup can take place. For example, certain dependencies need their bin directories added to the `PATH`. That is built-in, but other setup is done via a pluggable mechanism that works in conjunction with these dependency attributes. See <xref linkend="ssec-setup-hooks" /> for details.

Dependencies can be broken down along three axes: their host and target platforms relative to the new derivation’s, and whether they are propagated. The platform distinctions are motivated by cross compilation; see <xref linkend="chap-cross" /> for exactly what each platform means. [^footnote-stdenv-ignored-build-platform] But even if one is not cross compiling, the platforms imply whether or not the dependency is needed at run-time or build-time, a concept that makes perfect sense outside of cross compilation. By default, the run-time/build-time distinction is just a hint for mental clarity, but with `strictDeps` set it is mostly enforced even in the native case.

The extension of `PATH` with dependencies, alluded to above, proceeds according to the relative platforms alone. The process is carried out only for dependencies whose host platform matches the new derivation’s build platform i.e. dependencies which run on the platform where the new derivation will be built. [^footnote-stdenv-native-dependencies-in-path] For each dependency \<dep\> of those dependencies, `dep/bin`, if present, is added to the `PATH` environment variable.

The dependency is propagated when it forces some of its other-transitive (non-immediate) downstream dependencies to also take it on as an immediate dependency. Nix itself already takes a package’s transitive dependencies into account, but this propagation ensures nixpkgs-specific infrastructure like setup hooks (mentioned above) also are run as if the propagated dependency.

It is important to note that dependencies are not necessarily propagated as the same sort of dependency that they were before, but rather as the corresponding sort so that the platform rules still line up. The exact rules for dependency propagation can be given by assigning to each dependency two integers based one how its host and target platforms are offset from the depending derivation’s platforms. Those offsets are given below in the descriptions of each dependency list attribute. Algorithmically, we traverse propagated inputs, accumulating every propagated dependency’s propagated dependencies and adjusting them to account for the “shift in perspective” described by the current dependency’s platform offsets. This results in sort a transitive closure of the dependency relation, with the offsets being approximately summed when two dependency links are combined. We also prune transitive dependencies whose combined offsets go out-of-bounds, which can be viewed as a filter over that transitive closure removing dependencies that are blatantly absurd.

We can define the process precisely with [Natural Deduction](https://en.wikipedia.org/wiki/Natural_deduction) using the inference rules. This probably seems a bit obtuse, but so is the bash code that actually implements it! [^footnote-stdenv-find-inputs-location] They’re confusing in very different ways so… hopefully if something doesn’t make sense in one presentation, it will in the other!

```
let mapOffset(h, t, i) = i + (if i <= 0 then h else t - 1)

propagated-dep(h0, t0, A, B)
propagated-dep(h1, t1, B, C)
h0 + h1 in {-1, 0, 1}
h0 + t1 in {-1, 0, 1}
-------------------------------------- Transitive property
propagated-dep(mapOffset(h0, t0, h1),
               mapOffset(h0, t0, t1),
               A, C)
```

```
let mapOffset(h, t, i) = i + (if i <= 0 then h else t - 1)

dep(h0, _, A, B)
propagated-dep(h1, t1, B, C)
h0 + h1 in {-1, 0, 1}
h0 + t1 in {-1, 0, -1}
----------------------------- Take immediate dependencies' propagated dependencies
propagated-dep(mapOffset(h0, t0, h1),
               mapOffset(h0, t0, t1),
               A, C)
```

```
propagated-dep(h, t, A, B)
----------------------------- Propagated dependencies count as dependencies
dep(h, t, A, B)
```

Some explanation of this monstrosity is in order. In the common case, the target offset of a dependency is the successor to the target offset: `t = h + 1`. That means that:

```
let f(h, t, i) = i + (if i <= 0 then h else t - 1)
let f(h, h + 1, i) = i + (if i <= 0 then h else (h + 1) - 1)
let f(h, h + 1, i) = i + (if i <= 0 then h else h)
let f(h, h + 1, i) = i + h
```

This is where “sum-like” comes in from above: We can just sum all of the host offsets to get the host offset of the transitive dependency. The target offset is the transitive dependency is simply the host offset + 1, just as it was with the dependencies composed to make this transitive one; it can be ignored as it doesn’t add any new information.

Because of the bounds checks, the uncommon cases are `h = t` and `h + 2 = t`. In the former case, the motivation for `mapOffset` is that since its host and target platforms are the same, no transitive dependency of it should be able to “discover” an offset greater than its reduced target offsets. `mapOffset` effectively “squashes” all its transitive dependencies’ offsets so that none will ever be greater than the target offset of the original `h = t` package. In the other case, `h + 1` is skipped over between the host and target offsets. Instead of squashing the offsets, we need to “rip” them apart so no transitive dependencies’ offset is that one.

Overall, the unifying theme here is that propagation shouldn’t be introducing transitive dependencies involving platforms the depending package is unaware of. \[One can imagine the dependending package asking for dependencies with the platforms it knows about; other platforms it doesn’t know how to ask for. The platform description in that scenario is a kind of unforagable capability.\] The offset bounds checking and definition of `mapOffset` together ensure that this is the case. Discovering a new offset is discovering a new platform, and since those platforms weren’t in the derivation “spec” of the needing package, they cannot be relevant. From a capability perspective, we can imagine that the host and target platforms of a package are the capabilities a package requires, and the depending package must provide the capability to the dependency.

### Variables specifying dependencies
#### `depsBuildBuild` {#var-stdenv-depsBuildBuild}

A list of dependencies whose host and target platforms are the new derivation’s build platform. This means a `-1` host and `-1` target offset from the new derivation’s platforms. These are programs and libraries used at build time that produce programs and libraries also used at build time. If the dependency doesn’t care about the target platform (i.e. isn’t a compiler or similar tool), put it in `nativeBuildInputs` instead. The most common use of this `buildPackages.stdenv.cc`, the default C compiler for this role. That example crops up more than one might think in old commonly used C libraries.

Since these packages are able to be run at build-time, they are always added to the `PATH`, as described above. But since these packages are only guaranteed to be able to run then, they shouldn’t persist as run-time dependencies. This isn’t currently enforced, but could be in the future.

#### `nativeBuildInputs` {#var-stdenv-nativeBuildInputs}

A list of dependencies whose host platform is the new derivation’s build platform, and target platform is the new derivation’s host platform. This means a `-1` host offset and `0` target offset from the new derivation’s platforms. These are programs and libraries used at build-time that, if they are a compiler or similar tool, produce code to run at run-time—i.e. tools used to build the new derivation. If the dependency doesn’t care about the target platform (i.e. isn’t a compiler or similar tool), put it here, rather than in `depsBuildBuild` or `depsBuildTarget`. This could be called `depsBuildHost` but `nativeBuildInputs` is used for historical continuity.

Since these packages are able to be run at build-time, they are added to the `PATH`, as described above. But since these packages are only guaranteed to be able to run then, they shouldn’t persist as run-time dependencies. This isn’t currently enforced, but could be in the future.

#### `depsBuildTarget` {#var-stdenv-depsBuildTarget}

A list of dependencies whose host platform is the new derivation’s build platform, and target platform is the new derivation’s target platform. This means a `-1` host offset and `1` target offset from the new derivation’s platforms. These are programs used at build time that produce code to run with code produced by the depending package. Most commonly, these are tools used to build the runtime or standard library that the currently-being-built compiler will inject into any code it compiles. In many cases, the currently-being-built-compiler is itself employed for that task, but when that compiler won’t run (i.e. its build and host platform differ) this is not possible. Other times, the compiler relies on some other tool, like binutils, that is always built separately so that the dependency is unconditional.

This is a somewhat confusing concept to wrap one’s head around, and for good reason. As the only dependency type where the platform offsets are not adjacent integers, it requires thinking of a bootstrapping stage *two* away from the current one. It and its use-case go hand in hand and are both considered poor form: try to not need this sort of dependency, and try to avoid building standard libraries and runtimes in the same derivation as the compiler produces code using them. Instead strive to build those like a normal library, using the newly-built compiler just as a normal library would. In short, do not use this attribute unless you are packaging a compiler and are sure it is needed.

Since these packages are able to run at build time, they are added to the `PATH`, as described above. But since these packages are only guaranteed to be able to run then, they shouldn’t persist as run-time dependencies. This isn’t currently enforced, but could be in the future.

#### `depsHostHost` {#var-stdenv-depsHostHost}

A list of dependencies whose host and target platforms match the new derivation’s host platform. This means a `0` host offset and `0` target offset from the new derivation’s host platform. These are packages used at run-time to generate code also used at run-time. In practice, this would usually be tools used by compilers for macros or a metaprogramming system, or libraries used by the macros or metaprogramming code itself. It’s always preferable to use a `depsBuildBuild` dependency in the derivation being built over a `depsHostHost` on the tool doing the building for this purpose.

#### `buildInputs` {#var-stdenv-buildInputs}

A list of dependencies whose host platform and target platform match the new derivation’s. This means a `0` host offset and a `1` target offset from the new derivation’s host platform. This would be called `depsHostTarget` but for historical continuity. If the dependency doesn’t care about the target platform (i.e. isn’t a compiler or similar tool), put it here, rather than in `depsBuildBuild`.

These are often programs and libraries used by the new derivation at *run*-time, but that isn’t always the case. For example, the machine code in a statically-linked library is only used at run-time, but the derivation containing the library is only needed at build-time. Even in the dynamic case, the library may also be needed at build-time to appease the linker.

#### `depsTargetTarget` {#var-stdenv-depsTargetTarget}

A list of dependencies whose host platform matches the new derivation’s target platform. This means a `1` offset from the new derivation’s platforms. These are packages that run on the target platform, e.g. the standard library or run-time deps of standard library that a compiler insists on knowing about. It’s poor form in almost all cases for a package to depend on another from a future stage \[future stage corresponding to positive offset\]. Do not use this attribute unless you are packaging a compiler and are sure it is needed.

#### `depsBuildBuildPropagated` {#var-stdenv-depsBuildBuildPropagated}

The propagated equivalent of `depsBuildBuild`. This perhaps never ought to be used, but it is included for consistency \[see below for the others\].

#### `propagatedNativeBuildInputs` {#var-stdenv-propagatedNativeBuildInputs}

The propagated equivalent of `nativeBuildInputs`. This would be called `depsBuildHostPropagated` but for historical continuity. For example, if package `Y` has `propagatedNativeBuildInputs = [X]`, and package `Z` has `buildInputs = [Y]`, then package `Z` will be built as if it included package `X` in its `nativeBuildInputs`. If instead, package `Z` has `nativeBuildInputs = [Y]`, then `Z` will be built as if it included `X` in the `depsBuildBuild` of package `Z`, because of the sum of the two `-1` host offsets.

#### `depsBuildTargetPropagated` {#var-stdenv-depsBuildTargetPropagated}

The propagated equivalent of `depsBuildTarget`. This is prefixed for the same reason of alerting potential users.

#### `depsHostHostPropagated` {#var-stdenv-depsHostHostPropagated}

The propagated equivalent of `depsHostHost`.

#### `propagatedBuildInputs` {#var-stdenv-propagatedBuildInputs}

The propagated equivalent of `buildInputs`. This would be called `depsHostTargetPropagated` but for historical continuity.

#### `depsTargetTargetPropagated` {#var-stdenv-depsTargetTargetPropagated}

The propagated equivalent of `depsTargetTarget`. This is prefixed for the same reason of alerting potential users.

## Attributes {#ssec-stdenv-attributes}

### Variables affecting `stdenv` initialisation

#### `NIX_DEBUG` {#var-stdenv-NIX_DEBUG}

A natural number indicating how much information to log. If set to 1 or higher, `stdenv` will print moderate debugging information during the build. In particular, the `gcc` and `ld` wrapper scripts will print out the complete command line passed to the wrapped tools. If set to 6 or higher, the `stdenv` setup script will be run with `set -x` tracing. If set to 7 or higher, the `gcc` and `ld` wrapper scripts will also be run with `set -x` tracing.

### Attributes affecting build properties

#### `enableParallelBuilding` {#var-stdenv-enableParallelBuilding}

If set to `true`, `stdenv` will pass specific flags to `make` and other build tools to enable parallel building with up to `build-cores` workers.

Unless set to `false`, some build systems with good support for parallel building including `cmake`, `meson`, and `qmake` will set it to `true`.

### Special variables

#### `passthru` {#var-stdenv-passthru}

This is an attribute set which can be filled with arbitrary values. For example:

```nix
passthru = {
  foo = "bar";
  baz = {
    value1 = 4;
    value2 = 5;
  };
}
```

Values inside it are not passed to the builder, so you can change them without triggering a rebuild. However, they can be accessed outside of a derivation directly, as if they were set inside a derivation itself, e.g. `hello.baz.value1`. We don’t specify any usage or schema of `passthru` - it is meant for values that would be useful outside the derivation in other parts of a Nix expression (e.g. in other derivations). An example would be to convey some specific dependency of your derivation which contains a program with plugins support. Later, others who make derivations with plugins can use passed-through dependency to ensure that their plugin would be binary-compatible with built program.

#### `passthru.updateScript` {#var-passthru-updateScript}

A script to be run by `maintainers/scripts/update.nix` when the package is matched. It needs to be an executable file, either on the file system:

```nix
passthru.updateScript = ./update.sh;
```

or inside the expression itself:

```nix
passthru.updateScript = writeScript "update-zoom-us" ''
  #!/usr/bin/env nix-shell
  #!nix-shell -i bash -p curl pcre common-updater-scripts

  set -eu -o pipefail

  version="$(curl -sI https://zoom.us/client/latest/zoom_x86_64.tar.xz | grep -Fi 'Location:' | pcregrep -o1 '/(([0-9]\.?)+)/')"
  update-source-version zoom-us "$version"
'';
```

The attribute can also contain a list, a script followed by arguments to be passed to it:

```nix
passthru.updateScript = [ ../../update.sh pname "--requested-release=unstable" ];
```

The script will be run with `UPDATE_NIX_ATTR_PATH` environment variable set to the attribute path it is supposed to update.

::: note
The script will be usually run from the root of the Nixpkgs repository but you should not rely on that. Also note that the update scripts will be run in parallel by default; you should avoid running `git commit` or any other commands that cannot handle that.
:::

For information about how to run the updates, execute `nix-shell maintainers/scripts/update.nix`.

## Phases {#sec-stdenv-phases}

The generic builder has a number of *phases*. Package builds are split into phases to make it easier to override specific parts of the build (e.g., unpacking the sources or installing the binaries). Furthermore, it allows a nicer presentation of build logs in the Nix build farm.

Each phase can be overridden in its entirety either by setting the environment variable `namePhase` to a string containing some shell commands to be executed, or by redefining the shell function `namePhase`. The former is convenient to override a phase from the derivation, while the latter is convenient from a build script. However, typically one only wants to *add* some commands to a phase, e.g. by defining `postInstall` or `preFixup`, as skipping some of the default actions may have unexpected consequences. The default script for each phase is defined in the file `pkgs/stdenv/generic/setup.sh`.

### Controlling phases {#ssec-controlling-phases}

There are a number of variables that control what phases are executed and in what order:

#### Variables affecting phase control

##### `phases` {#var-stdenv-phases}

Specifies the phases. You can change the order in which phases are executed, or add new phases, by setting this variable. If it’s not set, the default value is used, which is `$prePhases unpackPhase patchPhase $preConfigurePhases configurePhase $preBuildPhases buildPhase checkPhase $preInstallPhases installPhase fixupPhase installCheckPhase $preDistPhases distPhase $postPhases`.

Usually, if you just want to add a few phases, it’s more convenient to set one of the variables below (such as `preInstallPhases`), as you then don’t specify all the normal phases.

##### `prePhases` {#var-stdenv-prePhases}

Additional phases executed before any of the default phases.

##### `preConfigurePhases` {#var-stdenv-preConfigurePhases}

Additional phases executed just before the configure phase.

##### `preBuildPhases` {#var-stdenv-preBuildPhases}

Additional phases executed just before the build phase.

##### `preInstallPhases` {#var-stdenv-preInstallPhases}

Additional phases executed just before the install phase.

##### `preFixupPhases` {#var-stdenv-preFixupPhases}

Additional phases executed just before the fixup phase.

##### `preDistPhases` {#var-stdenv-preDistPhases}

Additional phases executed just before the distribution phase.

##### `postPhases` {#var-stdenv-postPhases}

Additional phases executed after any of the default phases.

### The unpack phase {#ssec-unpack-phase}

The unpack phase is responsible for unpacking the source code of the package. The default implementation of `unpackPhase` unpacks the source files listed in the `src` environment variable to the current directory. It supports the following files by default:

#### Tar files

These can optionally be compressed using `gzip` (`.tar.gz`, `.tgz` or `.tar.Z`), `bzip2` (`.tar.bz2`, `.tbz2` or `.tbz`) or `xz` (`.tar.xz`, `.tar.lzma` or `.txz`).

#### Zip files

Zip files are unpacked using `unzip`. However, `unzip` is not in the standard environment, so you should add it to `nativeBuildInputs` yourself.

#### Directories in the Nix store

These are simply copied to the current directory. The hash part of the file name is stripped, e.g. `/nix/store/1wydxgby13cz...-my-sources` would be copied to `my-sources`.

Additional file types can be supported by setting the `unpackCmd` variable (see below).

#### Variables controlling the unpack phase
##### `srcs` / `src` {#var-stdenv-src}

The list of source files or directories to be unpacked or copied. One of these must be set.

##### `sourceRoot` {#var-stdenv-sourceRoot}

After running `unpackPhase`, the generic builder changes the current directory to the directory created by unpacking the sources. If there are multiple source directories, you should set `sourceRoot` to the name of the intended directory.

##### `setSourceRoot` {#var-stdenv-setSourceRoot}

Alternatively to setting `sourceRoot`, you can set `setSourceRoot` to a shell command to be evaluated by the unpack phase after the sources have been unpacked. This command must set `sourceRoot`.

##### `preUnpack` {#var-stdenv-preUnpack}

Hook executed at the start of the unpack phase.

##### `postUnpack` {#var-stdenv-postUnpack}

Hook executed at the end of the unpack phase.

##### `dontUnpack` {#var-stdenv-dontUnpack}

Set to true to skip the unpack phase.

##### `dontMakeSourcesWritable` {#var-stdenv-dontMakeSourcesWritable}

If set to `1`, the unpacked sources are *not* made writable. By default, they are made writable to prevent problems with read-only sources. For example, copied store directories would be read-only without this.

##### `unpackCmd` {#var-stdenv-unpackCmd}

The unpack phase evaluates the string `$unpackCmd` for any unrecognised file. The path to the current source file is contained in the `curSrc` variable.

### The patch phase {#ssec-patch-phase}

The patch phase applies the list of patches defined in the `patches` variable.

#### Variables controlling the patch phase

##### `dontPatch` {#var-stdenv-dontPatch}

Set to true to skip the patch phase.

##### `patches` {#var-stdenv-patches}

The list of patches. They must be in the format accepted by the `patch` command, and may optionally be compressed using `gzip` (`.gz`), `bzip2` (`.bz2`) or `xz` (`.xz`).

##### `patchFlags` {#var-stdenv-patchFlags}

Flags to be passed to `patch`. If not set, the argument `-p1` is used, which causes the leading directory component to be stripped from the file names in each patch.

##### `prePatch` {#var-stdenv-prePatch}

Hook executed at the start of the patch phase.

##### `postPatch` {#var-stdenv-postPatch}

Hook executed at the end of the patch phase.

### The configure phase {#ssec-configure-phase}

The configure phase prepares the source tree for building. The default `configurePhase` runs `./configure` (typically an Autoconf-generated script) if it exists.

#### Variables controlling the configure phase

##### `configureScript` {#var-stdenv-configureScript}

The name of the configure script. It defaults to `./configure` if it exists; otherwise, the configure phase is skipped. This can actually be a command (like `perl ./Configure.pl`).

##### `configureFlags` {#var-stdenv-configureFlags}

A list of strings passed as additional arguments to the configure script.

##### `dontConfigure` {#var-stdenv-dontConfigure}

Set to true to skip the configure phase.

##### `configureFlagsArray` {#var-stdenv-configureFlagsArray}

A shell array containing additional arguments passed to the configure script. You must use this instead of `configureFlags` if the arguments contain spaces.

##### `dontAddPrefix` {#var-stdenv-dontAddPrefix}

By default, the flag `--prefix=$prefix` is added to the configure flags. If this is undesirable, set this variable to true.

##### `prefix` {#var-stdenv-prefix}

The prefix under which the package must be installed, passed via the `--prefix` option to the configure script. It defaults to `$out`.

##### `prefixKey` {#var-stdenv-prefixKey}

The key to use when specifying the prefix. By default, this is set to `--prefix=` as that is used by the majority of packages.

##### `dontAddDisableDepTrack` {#var-stdenv-dontAddDisableDepTrack}

By default, the flag `--disable-dependency-tracking` is added to the configure flags to speed up Automake-based builds. If this is undesirable, set this variable to true.

##### `dontFixLibtool` {#var-stdenv-dontFixLibtool}

By default, the configure phase applies some special hackery to all files called `ltmain.sh` before running the configure script in order to improve the purity of Libtool-based packages [^footnote-stdenv-sys-lib-search-path] . If this is undesirable, set this variable to true.

##### `dontDisableStatic` {#var-stdenv-dontDisableStatic}

By default, when the configure script has `--enable-static`, the option `--disable-static` is added to the configure flags.

If this is undesirable, set this variable to true.

##### `configurePlatforms` {#var-stdenv-configurePlatforms}

By default, when cross compiling, the configure script has `--build=...` and `--host=...` passed. Packages can instead pass `[ "build" "host" "target" ]` or a subset to control exactly which platform flags are passed. Compilers and other tools can use this to also pass the target platform. [^footnote-stdenv-build-time-guessing-impurity]

##### `preConfigure` {#var-stdenv-preConfigure}

Hook executed at the start of the configure phase.

##### `postConfigure` {#var-stdenv-postConfigure}

Hook executed at the end of the configure phase.

### The build phase {#build-phase}

The build phase is responsible for actually building the package (e.g. compiling it). The default `buildPhase` simply calls `make` if a file named `Makefile`, `makefile` or `GNUmakefile` exists in the current directory (or the `makefile` is explicitly set); otherwise it does nothing.

#### Variables controlling the build phase

##### `dontBuild` {#var-stdenv-dontBuild}

Set to true to skip the build phase.

##### `makefile` {#var-stdenv-makefile}

The file name of the Makefile.

##### `makeFlags` {#var-stdenv-makeFlags}

A list of strings passed as additional flags to `make`. These flags are also used by the default install and check phase. For setting make flags specific to the build phase, use `buildFlags` (see below).

```nix
makeFlags = [ "PREFIX=$(out)" ];
```

::: note
The flags are quoted in bash, but environment variables can be specified by using the make syntax.
:::

##### `makeFlagsArray` {#var-stdenv-makeFlagsArray}

A shell array containing additional arguments passed to `make`. You must use this instead of `makeFlags` if the arguments contain spaces, e.g.

```nix
preBuild = ''
  makeFlagsArray+=(CFLAGS="-O0 -g" LDFLAGS="-lfoo -lbar")
'';
```

Note that shell arrays cannot be passed through environment variables, so you cannot set `makeFlagsArray` in a derivation attribute (because those are passed through environment variables): you have to define them in shell code.

##### `buildFlags` / `buildFlagsArray` {#var-stdenv-buildFlags}

A list of strings passed as additional flags to `make`. Like `makeFlags` and `makeFlagsArray`, but only used by the build phase.

##### `preBuild` {#var-stdenv-preBuild}

Hook executed at the start of the build phase.

##### `postBuild` {#var-stdenv-postBuild}

Hook executed at the end of the build phase.

You can set flags for `make` through the `makeFlags` variable.

Before and after running `make`, the hooks `preBuild` and `postBuild` are called, respectively.

### The check phase {#ssec-check-phase}

The check phase checks whether the package was built correctly by running its test suite. The default `checkPhase` calls `make check`, but only if the `doCheck` variable is enabled.

#### Variables controlling the check phase

##### `doCheck` {#var-stdenv-doCheck}

Controls whether the check phase is executed. By default it is skipped, but if `doCheck` is set to true, the check phase is usually executed. Thus you should set

```nix
doCheck = true;
```

in the derivation to enable checks. The exception is cross compilation. Cross compiled builds never run tests, no matter how `doCheck` is set, as the newly-built program won’t run on the platform used to build it.

##### `makeFlags` / `makeFlagsArray` / `makefile`

See the [build phase](#var-stdenv-makeFlags) for details.

##### `checkTarget` {#var-stdenv-checkTarget}

The make target that runs the tests. Defaults to `check`.

##### `checkFlags` / `checkFlagsArray` {#var-stdenv-checkFlags}

A list of strings passed as additional flags to `make`. Like `makeFlags` and `makeFlagsArray`, but only used by the check phase.

##### `checkInputs` {#var-stdenv-checkInputs}

A list of dependencies used by the phase. This gets included in `nativeBuildInputs` when `doCheck` is set.

##### `preCheck` {#var-stdenv-preCheck}

Hook executed at the start of the check phase.

##### `postCheck` {#var-stdenv-postCheck}

Hook executed at the end of the check phase.

### The install phase {#ssec-install-phase}

The install phase is responsible for installing the package in the Nix store under `out`. The default `installPhase` creates the directory `$out` and calls `make install`.

#### Variables controlling the install phase

##### `dontInstall` {#var-stdenv-dontInstall}

Set to true to skip the install phase.

##### `makeFlags` / `makeFlagsArray` / `makefile`

See the [build phase](#var-stdenv-makeFlags) for details.

##### `installTargets` {#var-stdenv-installTargets}

The make targets that perform the installation. Defaults to `install`. Example:

```nix
installTargets = "install-bin install-doc";
```

##### `installFlags` / `installFlagsArray` {#var-stdenv-installFlags}

A list of strings passed as additional flags to `make`. Like `makeFlags` and `makeFlagsArray`, but only used by the install phase.

##### `preInstall` {#var-stdenv-preInstall}

Hook executed at the start of the install phase.

##### `postInstall` {#var-stdenv-postInstall}

Hook executed at the end of the install phase.

### The fixup phase {#ssec-fixup-phase}

The fixup phase performs some (Nix-specific) post-processing actions on the files installed under `$out` by the install phase. The default `fixupPhase` does the following:

- It moves the `man/`, `doc/` and `info/` subdirectories of `$out` to `share/`.
- It strips libraries and executables of debug information.
- On Linux, it applies the `patchelf` command to ELF executables and libraries to remove unused directories from the `RPATH` in order to prevent unnecessary runtime dependencies.
- It rewrites the interpreter paths of shell scripts to paths found in `PATH`. E.g., `/usr/bin/perl` will be rewritten to `/nix/store/some-perl/bin/perl` found in `PATH`.

#### Variables controlling the fixup phase

##### `dontFixup` {#var-stdenv-dontFixup}

Set to true to skip the fixup phase.

##### `dontStrip` {#var-stdenv-dontStrip}

If set, libraries and executables are not stripped. By default, they are.

##### `dontStripHost` {#var-stdenv-dontStripHost}

Like `dontStrip`, but only affects the `strip` command targetting the package’s host platform. Useful when supporting cross compilation, but otherwise feel free to ignore.

##### `dontStripTarget` {#var-stdenv-dontStripTarget}

Like `dontStrip`, but only affects the `strip` command targetting the packages’ target platform. Useful when supporting cross compilation, but otherwise feel free to ignore.

##### `dontMoveSbin` {#var-stdenv-dontMoveSbin}

If set, files in `$out/sbin` are not moved to `$out/bin`. By default, they are.

##### `stripAllList` {#var-stdenv-stripAllList}

List of directories to search for libraries and executables from which *all* symbols should be stripped. By default, it’s empty. Stripping all symbols is risky, since it may remove not just debug symbols but also ELF information necessary for normal execution.

##### `stripAllFlags` {#var-stdenv-stripAllFlags}

Flags passed to the `strip` command applied to the files in the directories listed in `stripAllList`. Defaults to `-s` (i.e. `--strip-all`).

##### `stripDebugList` {#var-stdenv-stripDebugList}

List of directories to search for libraries and executables from which only debugging-related symbols should be stripped. It defaults to `lib lib32 lib64 libexec bin sbin`.

##### `stripDebugFlags` {#var-stdenv-stripDebugFlags}

Flags passed to the `strip` command applied to the files in the directories listed in `stripDebugList`. Defaults to `-S` (i.e. `--strip-debug`).

##### `dontPatchELF` {#var-stdenv-dontPatchELF}

If set, the `patchelf` command is not used to remove unnecessary `RPATH` entries. Only applies to Linux.

##### `dontPatchShebangs` {#var-stdenv-dontPatchShebangs}

If set, scripts starting with `#!` do not have their interpreter paths rewritten to paths in the Nix store.

##### `dontPruneLibtoolFiles` {#var-stdenv-dontPruneLibtoolFiles}

If set, libtool `.la` files associated with shared libraries won’t have their `dependency_libs` field cleared.

##### `forceShare` {#var-stdenv-forceShare}

The list of directories that must be moved from `$out` to `$out/share`. Defaults to `man doc info`.

##### `setupHook` {#var-stdenv-setupHook}

A package can export a [setup hook](#ssec-setup-hooks) by setting this variable. The setup hook, if defined, is copied to `$out/nix-support/setup-hook`. Environment variables are then substituted in it using `substituteAll`.

##### `preFixup` {#var-stdenv-preFixup}

Hook executed at the start of the fixup phase.

##### `postFixup` {#var-stdenv-postFixup}

Hook executed at the end of the fixup phase.

##### `separateDebugInfo` {#stdenv-separateDebugInfo}

If set to `true`, the standard environment will enable debug information in C/C++ builds. After installation, the debug information will be separated from the executables and stored in the output named `debug`. (This output is enabled automatically; you don’t need to set the `outputs` attribute explicitly.) To be precise, the debug information is stored in `debug/lib/debug/.build-id/XX/YYYY…`, where \<XXYYYY…\> is the \<build ID\> of the binary — a SHA-1 hash of the contents of the binary. Debuggers like GDB use the build ID to look up the separated debug information.

For example, with GDB, you can add

```
set debug-file-directory ~/.nix-profile/lib/debug
```

to `~/.gdbinit`. GDB will then be able to find debug information installed via `nix-env -i`.

### The installCheck phase {#ssec-installCheck-phase}

The installCheck phase checks whether the package was installed correctly by running its test suite against the installed directories. The default `installCheck` calls `make installcheck`.

#### Variables controlling the installCheck phase

##### `doInstallCheck` {#var-stdenv-doInstallCheck}

Controls whether the installCheck phase is executed. By default it is skipped, but if `doInstallCheck` is set to true, the installCheck phase is usually executed. Thus you should set

```nix
doInstallCheck = true;
```

in the derivation to enable install checks. The exception is cross compilation. Cross compiled builds never run tests, no matter how `doInstallCheck` is set, as the newly-built program won’t run on the platform used to build it.

##### `installCheckTarget` {#var-stdenv-installCheckTarget}

The make target that runs the install tests. Defaults to `installcheck`.

##### `installCheckFlags` / `installCheckFlagsArray` {#var-stdenv-installCheckFlags}

A list of strings passed as additional flags to `make`. Like `makeFlags` and `makeFlagsArray`, but only used by the installCheck phase.

##### `installCheckInputs` {#var-stdenv-installCheckInputs}

A list of dependencies used by the phase. This gets included in `nativeBuildInputs` when `doInstallCheck` is set.

##### `preInstallCheck` {#var-stdenv-preInstallCheck}

Hook executed at the start of the installCheck phase.

##### `postInstallCheck` {#var-stdenv-postInstallCheck}

Hook executed at the end of the installCheck phase.

### The distribution phase {#ssec-distribution-phase}

The distribution phase is intended to produce a source distribution of the package. The default `distPhase` first calls `make dist`, then it copies the resulting source tarballs to `$out/tarballs/`. This phase is only executed if the attribute `doDist` is set.

#### Variables controlling the distribution phase

##### `distTarget` {#var-stdenv-distTarget}

The make target that produces the distribution. Defaults to `dist`.

##### `distFlags` / `distFlagsArray` {#var-stdenv-distFlags}

Additional flags passed to `make`.

##### `tarballs` {#var-stdenv-tarballs}

The names of the source distribution files to be copied to `$out/tarballs/`. It can contain shell wildcards. The default is `*.tar.gz`.

##### `dontCopyDist` {#var-stdenv-dontCopyDist}

If set, no files are copied to `$out/tarballs/`.

##### `preDist` {#var-stdenv-preDist}

Hook executed at the start of the distribution phase.

##### `postDist` {#var-stdenv-postDist}

Hook executed at the end of the distribution phase.

## Shell functions {#ssec-stdenv-functions}

The standard environment provides a number of useful functions.

### `makeWrapper` \<executable\> \<wrapperfile\> \<args\> {#fun-makeWrapper}

Constructs a wrapper for a program with various possible arguments. For example:

```bash
# adds `FOOBAR=baz` to `$out/bin/foo`’s environment
makeWrapper $out/bin/foo $wrapperfile --set FOOBAR baz

# prefixes the binary paths of `hello` and `git`
# Be advised that paths often should be patched in directly
# (via string replacements or in `configurePhase`).
makeWrapper $out/bin/foo $wrapperfile --prefix PATH : ${lib.makeBinPath [ hello git ]}
```

There’s many more kinds of arguments, they are documented in `nixpkgs/pkgs/build-support/setup-hooks/make-wrapper.sh`.

`wrapProgram` is a convenience function you probably want to use most of the time.

### `substitute` \<infile\> \<outfile\> \<subs\> {#fun-substitute}

Performs string substitution on the contents of \<infile\>, writing the result to \<outfile\>. The substitutions in \<subs\> are of the following form:

#### `--replace` \<s1\> \<s2\>

Replace every occurrence of the string \<s1\> by \<s2\>.

#### `--subst-var` \<varName\>

Replace every occurrence of `@varName@` by the contents of the environment variable \<varName\>. This is useful for generating files from templates, using `@...@` in the template as placeholders.

#### `--subst-var-by` \<varName\> \<s\>

Replace every occurrence of `@varName@` by the string \<s\>.

Example:

```shell
substitute ./foo.in ./foo.out \
    --replace /usr/bin/bar $bar/bin/bar \
    --replace "a string containing spaces" "some other text" \
    --subst-var someVar
```

### `substituteInPlace` \<file\> \<subs\> {#fun-substituteInPlace}

Like `substitute`, but performs the substitutions in place on the file \<file\>.

### `substituteAll` \<infile\> \<outfile\> {#fun-substituteAll}

Replaces every occurrence of `@varName@`, where \<varName\> is any environment variable, in \<infile\>, writing the result to \<outfile\>. For instance, if \<infile\> has the contents

```bash
#! @bash@/bin/sh
PATH=@coreutils@/bin
echo @foo@
```

and the environment contains `bash=/nix/store/bmwp0q28cf21...-bash-3.2-p39` and `coreutils=/nix/store/68afga4khv0w...-coreutils-6.12`, but does not contain the variable `foo`, then the output will be

```bash
#! /nix/store/bmwp0q28cf21...-bash-3.2-p39/bin/sh
PATH=/nix/store/68afga4khv0w...-coreutils-6.12/bin
echo @foo@
```

That is, no substitution is performed for undefined variables.

Environment variables that start with an uppercase letter or an underscore are filtered out, to prevent global variables (like `HOME`) or private variables (like `__ETC_PROFILE_DONE`) from accidentally getting substituted. The variables also have to be valid bash "names", as defined in the bash manpage (alphanumeric or `_`, must not start with a number).

### `substituteAllInPlace` \<file\> {#fun-substituteAllInPlace}

Like `substituteAll`, but performs the substitutions in place on the file \<file\>.

### `stripHash` \<path\> {#fun-stripHash}

Strips the directory and hash part of a store path, outputting the name part to `stdout`. For example:

```bash
# prints coreutils-8.24
stripHash "/nix/store/9s9r019176g7cvn2nvcw41gsp862y6b4-coreutils-8.24"
```

If you wish to store the result in another variable, then the following idiom may be useful:

```bash
name="/nix/store/9s9r019176g7cvn2nvcw41gsp862y6b4-coreutils-8.24"
someVar=$(stripHash $name)
```

### `wrapProgram` \<executable\> \<makeWrapperArgs\> {#fun-wrapProgram}

Convenience function for `makeWrapper` that automatically creates a sane wrapper file. It takes all the same arguments as `makeWrapper`, except for `--argv0`.

It cannot be applied multiple times, since it will overwrite the wrapper file.

## Package setup hooks {#ssec-setup-hooks}

Nix itself considers a build-time dependency as merely something that should previously be built and accessible at build time—packages themselves are on their own to perform any additional setup. In most cases, that is fine, and the downstream derivation can deal with its own dependencies. But for a few common tasks, that would result in almost every package doing the same sort of setup work—depending not on the package itself, but entirely on which dependencies were used.

In order to alleviate this burden, the setup hook mechanism was written, where any package can include a shell script that \[by convention rather than enforcement by Nix\], any downstream reverse-dependency will source as part of its build process. That allows the downstream dependency to merely specify its dependencies, and lets those dependencies effectively initialize themselves. No boilerplate mirroring the list of dependencies is needed.

The setup hook mechanism is a bit of a sledgehammer though: a powerful feature with a broad and indiscriminate area of effect. The combination of its power and implicit use may be expedient, but isn’t without costs. Nix itself is unchanged, but the spirit of added dependencies being effect-free is violated even if the letter isn’t. For example, if a derivation path is mentioned more than once, Nix itself doesn’t care and simply makes sure the dependency derivation is already built just the same—depending is just needing something to exist, and needing is idempotent. However, a dependency specified twice will have its setup hook run twice, and that could easily change the build environment (though a well-written setup hook will therefore strive to be idempotent so this is in fact not observable). More broadly, setup hooks are anti-modular in that multiple dependencies, whether the same or different, should not interfere and yet their setup hooks may well do so.

The most typical use of the setup hook is actually to add other hooks which are then run (i.e. after all the setup hooks) on each dependency. For example, the C compiler wrapper’s setup hook feeds itself flags for each dependency that contains relevant libraries and headers. This is done by defining a bash function, and appending its name to one of `envBuildBuildHooks`, `envBuildHostHooks`, `envBuildTargetHooks`, `envHostHostHooks`, `envHostTargetHooks`, or `envTargetTargetHooks`. These 6 bash variables correspond to the 6 sorts of dependencies by platform (there’s 12 total but we ignore the propagated/non-propagated axis).

Packages adding a hook should not hard code a specific hook, but rather choose a variable *relative* to how they are included. Returning to the C compiler wrapper example, if the wrapper itself is an `n` dependency, then it only wants to accumulate flags from `n + 1` dependencies, as only those ones match the compiler’s target platform. The `hostOffset` variable is defined with the current dependency’s host offset `targetOffset` with its target offset, before its setup hook is sourced. Additionally, since most environment hooks don’t care about the target platform, that means the setup hook can append to the right bash array by doing something like

```{.bash}
addEnvHooks "$hostOffset" myBashFunction
```

The *existence* of setups hooks has long been documented and packages inside Nixpkgs are free to use this mechanism. Other packages, however, should not rely on these mechanisms not changing between Nixpkgs versions. Because of the existing issues with this system, there’s little benefit from mandating it be stable for any period of time.

First, let’s cover some setup hooks that are part of Nixpkgs default stdenv. This means that they are run for every package built using `stdenv.mkDerivation`. Some of these are platform specific, so they may run on Linux but not Darwin or vice-versa.

### `move-docs.sh`

This setup hook moves any installed documentation to the `/share` subdirectory directory. This includes the man, doc and info directories. This is needed for legacy programs that do not know how to use the `share` subdirectory.

### `compress-man-pages.sh`

This setup hook compresses any man pages that have been installed. The compression is done using the gzip program. This helps to reduce the installed size of packages.

### `strip.sh`

This runs the strip command on installed binaries and libraries. This removes unnecessary information like debug symbols when they are not needed. This also helps to reduce the installed size of packages.

### `patch-shebangs.sh`

This setup hook patches installed scripts to use the full path to the shebang interpreter. A shebang interpreter is the first commented line of a script telling the operating system which program will run the script (e.g `#!/bin/bash`). In Nix, we want an exact path to that interpreter to be used. This often replaces `/bin/sh` with a path in the Nix store.

### `audit-tmpdir.sh`

This verifies that no references are left from the install binaries to the directory used to build those binaries. This ensures that the binaries do not need things outside the Nix store. This is currently supported in Linux only.

### `multiple-outputs.sh`

This setup hook adds configure flags that tell packages to install files into any one of the proper outputs listed in `outputs`. This behavior can be turned off by setting `setOutputFlags` to false in the derivation environment. See <xref linkend="chap-multiple-output" /> for more information.

### `move-sbin.sh`

This setup hook moves any binaries installed in the `sbin/` subdirectory into `bin/`. In addition, a link is provided from `sbin/` to `bin/` for compatibility.

### `move-lib64.sh`

This setup hook moves any libraries installed in the `lib64/` subdirectory into `lib/`. In addition, a link is provided from `lib64/` to `lib/` for compatibility.

### `move-systemd-user-units.sh`

This setup hook moves any systemd user units installed in the `lib/` subdirectory into `share/`. In addition, a link is provided from `share/` to `lib/` for compatibility. This is needed for systemd to find user services when installed into the user profile.

### `set-source-date-epoch-to-latest.sh`

This sets `SOURCE_DATE_EPOCH` to the modification time of the most recent file.

### Bintools Wrapper

The Bintools Wrapper wraps the binary utilities for a bunch of miscellaneous purposes. These are GNU Binutils when targetting Linux, and a mix of cctools and GNU binutils for Darwin. \[The “Bintools” name is supposed to be a compromise between “Binutils” and “cctools” not denoting any specific implementation.\] Specifically, the underlying bintools package, and a C standard library (glibc or Darwin’s libSystem, just for the dynamic loader) are all fed in, and dependency finding, hardening (see below), and purity checks for each are handled by the Bintools Wrapper. Packages typically depend on CC Wrapper, which in turn (at run time) depends on the Bintools Wrapper.

The Bintools Wrapper was only just recently split off from CC Wrapper, so the division of labor is still being worked out. For example, it shouldn’t care about the C standard library, but just take a derivation with the dynamic loader (which happens to be the glibc on linux). Dependency finding however is a task both wrappers will continue to need to share, and probably the most important to understand. It is currently accomplished by collecting directories of host-platform dependencies (i.e. `buildInputs` and `nativeBuildInputs`) in environment variables. The Bintools Wrapper’s setup hook causes any `lib` and `lib64` subdirectories to be added to `NIX_LDFLAGS`. Since the CC Wrapper and the Bintools Wrapper use the same strategy, most of the Bintools Wrapper code is sparsely commented and refers to the CC Wrapper. But the CC Wrapper’s code, by contrast, has quite lengthy comments. The Bintools Wrapper merely cites those, rather than repeating them, to avoid falling out of sync.

A final task of the setup hook is defining a number of standard environment variables to tell build systems which executables fulfill which purpose. They are defined to just be the base name of the tools, under the assumption that the Bintools Wrapper’s binaries will be on the path. Firstly, this helps poorly-written packages, e.g. ones that look for just `gcc` when `CC` isn’t defined yet `clang` is to be used. Secondly, this helps packages not get confused when cross-compiling, in which case multiple Bintools Wrappers may simultaneously be in use. [^footnote-stdenv-per-platform-wrapper] `BUILD_`- and `TARGET_`-prefixed versions of the normal environment variable are defined for additional Bintools Wrappers, properly disambiguating them.

A problem with this final task is that the Bintools Wrapper is honest and defines `LD` as `ld`. Most packages, however, firstly use the C compiler for linking, secondly use `LD` anyways, defining it as the C compiler, and thirdly, only so define `LD` when it is undefined as a fallback. This triple-threat means Bintools Wrapper will break those packages, as LD is already defined as the actual linker which the package won’t override yet doesn’t want to use. The workaround is to define, just for the problematic package, `LD` as the C compiler. A good way to do this would be `preConfigure = "LD=$CC"`.

### CC Wrapper

The CC Wrapper wraps a C toolchain for a bunch of miscellaneous purposes. Specifically, a C compiler (GCC or Clang), wrapped binary tools, and a C standard library (glibc or Darwin’s libSystem, just for the dynamic loader) are all fed in, and dependency finding, hardening (see below), and purity checks for each are handled by the CC Wrapper. Packages typically depend on the CC Wrapper, which in turn (at run-time) depends on the Bintools Wrapper.

Dependency finding is undoubtedly the main task of the CC Wrapper. This works just like the Bintools Wrapper, except that any `include` subdirectory of any relevant dependency is added to `NIX_CFLAGS_COMPILE`. The setup hook itself contains some lengthy comments describing the exact convoluted mechanism by which this is accomplished.

Similarly, the CC Wrapper follows the Bintools Wrapper in defining standard environment variables with the names of the tools it wraps, for the same reasons described above. Importantly, while it includes a `cc` symlink to the c compiler for portability, the `CC` will be defined using the compiler’s “real name” (i.e. `gcc` or `clang`). This helps lousy build systems that inspect on the name of the compiler rather than run it.

Here are some more packages that provide a setup hook. Since the list of hooks is extensible, this is not an exhaustive list. The mechanism is only to be used as a last resort, so it might cover most uses.

### Perl {#setup-hook-perl}

Adds the `lib/site_perl` subdirectory of each build input to the `PERL5LIB` environment variable. For instance, if `buildInputs` contains Perl, then the `lib/site_perl` subdirectory of each input is added to the `PERL5LIB` environment variable.

### Python {#setup-hook-python}

Adds the `lib/${python.libPrefix}/site-packages` subdirectory of each build input to the `PYTHONPATH` environment variable.

### pkg-config {#setup-hook-pkg-config}

Adds the `lib/pkgconfig` and `share/pkgconfig` subdirectories of each build input to the `PKG_CONFIG_PATH` environment variable.

### Automake {#setup-hook-automake}

Adds the `share/aclocal` subdirectory of each build input to the `ACLOCAL_PATH` environment variable.

### Autoconf {#setup-hook-autoconf}

The `autoreconfHook` derivation adds `autoreconfPhase`, which runs autoreconf, libtoolize and automake, essentially preparing the configure script in autotools-based builds. Most autotools-based packages come with the configure script pre-generated, but this hook is necessary for a few packages and when you need to patch the package’s configure scripts.

### libxml2 {#setup-hook-libxml2}

Adds every file named `catalog.xml` found under the `xml/dtd` and `xml/xsl` subdirectories of each build input to the `XML_CATALOG_FILES` environment variable.

### teTeX / TeX Live

Adds the `share/texmf-nix` subdirectory of each build input to the `TEXINPUTS` environment variable.

### Qt 4

Sets the `QTDIR` environment variable to Qt’s path.

### gdk-pixbuf {#setup-hook-gdk-pixbuf}

Exports `GDK_PIXBUF_MODULE_FILE` environment variable to the builder. Add librsvg package to `buildInputs` to get svg support. See also the [setup hook description in GNOME platform docs](#ssec-gnome-hooks-gdk-pixbuf).

### GHC

Creates a temporary package database and registers every Haskell build input in it (TODO: how?).

### GNOME platform

Hooks related to GNOME platform and related libraries like GLib, GTK and GStreamer are described in <xref linkend="sec-language-gnome" />.

### autoPatchelfHook {#setup-hook-autopatchelfhook}

This is a special setup hook which helps in packaging proprietary software in that it automatically tries to find missing shared library dependencies of ELF files based on the given `buildInputs` and `nativeBuildInputs`.

You can also specify a `runtimeDependencies` variable which lists dependencies to be unconditionally added to rpath of all executables. This is useful for programs that use dlopen 3 to load libraries at runtime.

In certain situations you may want to run the main command (`autoPatchelf`) of the setup hook on a file or a set of directories instead of unconditionally patching all outputs. This can be done by setting the `dontAutoPatchelf` environment variable to a non-empty value.

By default `autoPatchelf` will fail as soon as any ELF file requires a dependency which cannot be resolved via the given build inputs. In some situations you might prefer to just leave missing dependencies unpatched and continue to patch the rest. This can be achieved by setting the `autoPatchelfIgnoreMissingDeps` environment variable to a non-empty value.

The `autoPatchelf` command also recognizes a `--no-recurse` command line flag, which prevents it from recursing into subdirectories.

### breakpointHook

This hook will make a build pause instead of stopping when a failure happens. It prevents nix from cleaning up the build environment immediately and allows the user to attach to a build environment using the `cntr` command. Upon build error it will print instructions on how to use `cntr`, which can be used to enter the environment for debugging. Installing cntr and running the command will provide shell access to the build sandbox of failed build. At `/var/lib/cntr` the sandboxed filesystem is mounted. All commands and files of the system are still accessible within the shell. To execute commands from the sandbox use the cntr exec subcommand. `cntr` is only supported on Linux-based platforms. To use it first add `cntr` to your `environment.systemPackages` on NixOS or alternatively to the root user on non-NixOS systems. Then in the package that is supposed to be inspected, add `breakpointHook` to `nativeBuildInputs`.

```nix
nativeBuildInputs = [ breakpointHook ];
```

When a build failure happens there will be an instruction printed that shows how to attach with `cntr` to the build sandbox.

::: note
::: title
Caution with remote builds
:::

This won’t work with remote builds as the build environment is on a different machine and can’t be accessed by `cntr`. Remote builds can be turned off by setting `--option builders ''` for `nix-build` or `--builders ''` for `nix build`.
:::

### installShellFiles

This hook helps with installing manpages and shell completion files. It exposes 2 shell functions `installManPage` and `installShellCompletion` that can be used from your `postInstall` hook.

The `installManPage` function takes one or more paths to manpages to install. The manpages must have a section suffix, and may optionally be compressed (with `.gz` suffix). This function will place them into the correct directory.

The `installShellCompletion` function takes one or more paths to shell completion files. By default it will autodetect the shell type from the completion file extension, but you may also specify it by passing one of `--bash`, `--fish`, or `--zsh`. These flags apply to all paths listed after them (up until another shell flag is given). Each path may also have a custom installation name provided by providing a flag `--name NAME` before the path. If this flag is not provided, zsh completions will be renamed automatically such that `foobar.zsh` becomes `_foobar`. A root name may be provided for all paths using the flag `--cmd NAME`; this synthesizes the appropriate name depending on the shell (e.g. `--cmd foo` will synthesize the name `foo.bash` for bash and `_foo` for zsh). The path may also be a fifo or named fd (such as produced by `<(cmd)`), in which case the shell and name must be provided.

```nix
nativeBuildInputs = [ installShellFiles ];
postInstall = ''
  installManPage doc/foobar.1 doc/barfoo.3
  # explicit behavior
  installShellCompletion --bash --name foobar.bash share/completions.bash
  installShellCompletion --fish --name foobar.fish share/completions.fish
  installShellCompletion --zsh --name _foobar share/completions.zsh
  # implicit behavior
  installShellCompletion share/completions/foobar.{bash,fish,zsh}
  # using named fd
  installShellCompletion --cmd foobar \
    --bash <($out/bin/foobar --bash-completion) \
    --fish <($out/bin/foobar --fish-completion) \
    --zsh <($out/bin/foobar --zsh-completion)
'';
```

### libiconv, libintl

A few libraries automatically add to `NIX_LDFLAGS` their library, making their symbols automatically available to the linker. This includes libiconv and libintl (gettext). This is done to provide compatibility between GNU Linux, where libiconv and libintl are bundled in, and other systems where that might not be the case. Sometimes, this behavior is not desired. To disable this behavior, set `dontAddExtraLibs`.

### validatePkgConfig

The `validatePkgConfig` hook validates all pkg-config (`.pc`) files in a package. This helps catching some common errors in pkg-config files, such as undefined variables.

### cmake

Overrides the default configure phase to run the CMake command. By default, we use the Make generator of CMake. In addition, dependencies are added automatically to CMAKE_PREFIX_PATH so that packages are correctly detected by CMake. Some additional flags are passed in to give similar behavior to configure-based packages. You can disable this hook’s behavior by setting configurePhase to a custom value, or by setting dontUseCmakeConfigure. cmakeFlags controls flags passed only to CMake. By default, parallel building is enabled as CMake supports parallel building almost everywhere. When Ninja is also in use, CMake will detect that and use the ninja generator.

### xcbuildHook

Overrides the build and install phases to run the "xcbuild" command. This hook is needed when a project only comes with build files for the XCode build system. You can disable this behavior by setting buildPhase and configurePhase to a custom value. xcbuildFlags controls flags passed only to xcbuild.

### Meson

Overrides the configure phase to run meson to generate Ninja files. To run these files, you should accompany Meson with ninja. By default, `enableParallelBuilding` is enabled as Meson supports parallel building almost everywhere.

#### Variables controlling Meson

##### `mesonFlags`

Controls the flags passed to meson.

##### `mesonBuildType`

Which [`--buildtype`](https://mesonbuild.com/Builtin-options.html#core-options) to pass to Meson. We default to `plain`.

##### `mesonAutoFeatures`

What value to set [`-Dauto_features=`](https://mesonbuild.com/Builtin-options.html#core-options) to. We default to `enabled`.

##### `mesonWrapMode`

What value to set [`-Dwrap_mode=`](https://mesonbuild.com/Builtin-options.html#core-options) to. We default to `nodownload` as we disallow network access.

##### `dontUseMesonConfigure`

Disables using Meson’s `configurePhase`.

### ninja

Overrides the build, install, and check phase to run ninja instead of make. You can disable this behavior with the `dontUseNinjaBuild`, `dontUseNinjaInstall`, and `dontUseNinjaCheck`, respectively. Parallel building is enabled by default in Ninja.

### unzip

This setup hook will allow you to unzip .zip files specified in `$src`. There are many similar packages like `unrar`, `undmg`, etc.

### wafHook

Overrides the configure, build, and install phases. This will run the “waf” script used by many projects. If `wafPath` (default `./waf`) doesn’t exist, it will copy the version of waf available in Nixpkgs. `wafFlags` can be used to pass flags to the waf script.

### scons

Overrides the build, install, and check phases. This uses the scons build system as a replacement for make. scons does not provide a configure phase, so everything is managed at build and install time.

## Purity in Nixpkgs {#sec-purity-in-nixpkgs}

*Measures taken to prevent dependencies on packages outside the store, and what you can do to prevent them.*

GCC doesn’t search in locations such as `/usr/include`. In fact, attempts to add such directories through the `-I` flag are filtered out. Likewise, the linker (from GNU binutils) doesn’t search in standard locations such as `/usr/lib`. Programs built on Linux are linked against a GNU C Library that likewise doesn’t search in the default system locations.

## Hardening in Nixpkgs {#sec-hardening-in-nixpkgs}

There are flags available to harden packages at compile or link-time. These can be toggled using the `stdenv.mkDerivation` parameters `hardeningDisable` and `hardeningEnable`.

Both parameters take a list of flags as strings. The special `"all"` flag can be passed to `hardeningDisable` to turn off all hardening. These flags can also be used as environment variables for testing or development purposes.

The following flags are enabled by default and might require disabling with `hardeningDisable` if the program to package is incompatible.

### `format`

Adds the `-Wformat -Wformat-security -Werror=format-security` compiler options. At present, this warns about calls to `printf` and `scanf` functions where the format string is not a string literal and there are no format arguments, as in `printf(foo);`. This may be a security hole if the format string came from untrusted input and contains `%n`.

This needs to be turned off or fixed for errors similar to:

```
/tmp/nix-build-zynaddsubfx-2.5.2.drv-0/zynaddsubfx-2.5.2/src/UI/guimain.cpp:571:28: error: format not a string literal and no format arguments [-Werror=format-security]
         printf(help_message);
                            ^
cc1plus: some warnings being treated as errors
```

### `stackprotector`

Adds the `-fstack-protector-strong --param ssp-buffer-size=4` compiler options. This adds safety checks against stack overwrites rendering many potential code injection attacks into aborting situations. In the best case this turns code injection vulnerabilities into denial of service or into non-issues (depending on the application).

This needs to be turned off or fixed for errors similar to:

```
bin/blib.a(bios_console.o): In function `bios_handle_cup':
/tmp/nix-build-ipxe-20141124-5cbdc41.drv-0/ipxe-5cbdc41/src/arch/i386/firmware/pcbios/bios_console.c:86: undefined reference to `__stack_chk_fail'
```

### `fortify`

Adds the `-O2 -D_FORTIFY_SOURCE=2` compiler options. During code generation the compiler knows a great deal of information about buffer sizes (where possible), and attempts to replace insecure unlimited length buffer function calls with length-limited ones. This is especially useful for old, crufty code. Additionally, format strings in writable memory that contain `%n` are blocked. If an application depends on such a format string, it will need to be worked around.

Additionally, some warnings are enabled which might trigger build failures if compiler warnings are treated as errors in the package build. In this case, set `NIX_CFLAGS_COMPILE` to `-Wno-error=warning-type`.

This needs to be turned off or fixed for errors similar to:

```
malloc.c:404:15: error: return type is an incomplete type
malloc.c:410:19: error: storage size of 'ms' isn't known

strdup.h:22:1: error: expected identifier or '(' before '__extension__'

strsep.c:65:23: error: register name not specified for 'delim'

installwatch.c:3751:5: error: conflicting types for '__open_2'

fcntl2.h:50:4: error: call to '__open_missing_mode' declared with attribute error: open with O_CREAT or O_TMPFILE in second argument needs 3 arguments
```

### `pic`

Adds the `-fPIC` compiler options. This options adds support for position independent code in shared libraries and thus making ASLR possible.

Most notably, the Linux kernel, kernel modules and other code not running in an operating system environment like boot loaders won’t build with PIC enabled. The compiler will is most cases complain that PIC is not supported for a specific build.

This needs to be turned off or fixed for assembler errors similar to:

```
ccbLfRgg.s: Assembler messages:
ccbLfRgg.s:33: Error: missing or invalid displacement expression `private_key_len@GOTOFF'
```

### `strictoverflow`

Signed integer overflow is undefined behaviour according to the C standard. If it happens, it is an error in the program as it should check for overflow before it can happen, not afterwards. GCC provides built-in functions to perform arithmetic with overflow checking, which are correct and faster than any custom implementation. As a workaround, the option `-fno-strict-overflow` makes gcc behave as if signed integer overflows were defined.

This flag should not trigger any build or runtime errors.

### `relro`

Adds the `-z relro` linker option. During program load, several ELF memory sections need to be written to by the linker, but can be turned read-only before turning over control to the program. This prevents some GOT (and .dtors) overwrite attacks, but at least the part of the GOT used by the dynamic linker (.got.plt) is still vulnerable.

This flag can break dynamic shared object loading. For instance, the module systems of Xorg and OpenCV are incompatible with this flag. In almost all cases the `bindnow` flag must also be disabled and incompatible programs typically fail with similar errors at runtime.

### `bindnow`

Adds the `-z bindnow` linker option. During program load, all dynamic symbols are resolved, allowing for the complete GOT to be marked read-only (due to `relro`). This prevents GOT overwrite attacks. For very large applications, this can incur some performance loss during initial load while symbols are resolved, but this shouldn’t be an issue for daemons.

This flag can break dynamic shared object loading. For instance, the module systems of Xorg and PHP are incompatible with this flag. Programs incompatible with this flag often fail at runtime due to missing symbols, like:

```
intel_drv.so: undefined symbol: vgaHWFreeHWRec
```

The following flags are disabled by default and should be enabled with `hardeningEnable` for packages that take untrusted input like network services.

### `pie`

Adds the `-fPIE` compiler and `-pie` linker options. Position Independent Executables are needed to take advantage of Address Space Layout Randomization, supported by modern kernel versions. While ASLR can already be enforced for data areas in the stack and heap (brk and mmap), the code areas must be compiled as position-independent. Shared libraries already do this with the `pic` flag, so they gain ASLR automatically, but binary .text regions need to be build with `pie` to gain ASLR. When this happens, ROP attacks are much harder since there are no static locations to bounce off of during a memory corruption attack.

For more in-depth information on these hardening flags and hardening in general, refer to the [Debian Wiki](https://wiki.debian.org/Hardening), [Ubuntu Wiki](https://wiki.ubuntu.com/Security/Features), [Gentoo Wiki](https://wiki.gentoo.org/wiki/Project:Hardened), and the [Arch Wiki](https://wiki.archlinux.org/index.php/DeveloperWiki:Security).

[^footnote-stdenv-ignored-build-platform]: The build platform is ignored because it is a mere implementation detail of the package satisfying the dependency: As a general programming principle, dependencies are always *specified* as interfaces, not concrete implementation.
[^footnote-stdenv-native-dependencies-in-path]: Currently, this means for native builds all dependencies are put on the `PATH`. But in the future that may not be the case for sake of matching cross: the platforms would be assumed to be unique for native and cross builds alike, so only the `depsBuild*` and `nativeBuildInputs` would be added to the `PATH`.
[^footnote-stdenv-find-inputs-location]: The `findInputs` function, currently residing in `pkgs/stdenv/generic/setup.sh`, implements the propagation logic.
[^footnote-stdenv-sys-lib-search-path]: It clears the `sys_lib_*search_path` variables in the Libtool script to prevent Libtool from using libraries in `/usr/lib` and such.
[^footnote-stdenv-build-time-guessing-impurity]: Eventually these will be passed building natively as well, to improve determinism: build-time guessing, as is done today, is a risk of impurity.
[^footnote-stdenv-per-platform-wrapper]: Each wrapper targets a single platform, so if binaries for multiple platforms are needed, the underlying binaries must be wrapped multiple times. As this is a property of the wrapper itself, the multiple wrappings are needed whether or not the same underlying binaries can target multiple platforms.
