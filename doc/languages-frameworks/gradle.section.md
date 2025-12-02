# Gradle {#gradle}

Gradle is a popular build tool for Java/Kotlin. Gradle itself doesn't
currently provide tools to make dependency resolution reproducible, so
nixpkgs has a proxy designed for intercepting Gradle web requests to
record dependencies so they can be restored in a reproducible fashion.

## Building a Gradle package {#building-a-gradle-package}

Here's how a typical derivation will look:

```nix
stdenv.mkDerivation (finalAttrs: {
  pname = "pdftk";
  version = "3.3.3";

  src = fetchFromGitLab {
    owner = "pdftk-java";
    repo = "pdftk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ciKotTHSEcITfQYKFZ6sY2LZnXGChBJy0+eno8B3YHY=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  # if the package has dependencies, mitmCache must be set
  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  # this is required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  # defaults to "assemble"
  gradleBuildTask = "shadowJar";

  # will run the gradleCheckTask (defaults to "test")
  doCheck = true;

  installPhase = ''
    mkdir -p $out/{bin,share/pdftk}
    cp build/libs/pdftk-all.jar $out/share/pdftk

    makeWrapper ${lib.getExe jre} $out/bin/pdftk \
      --add-flags "-jar $out/share/pdftk/pdftk-all.jar"

    cp ${finalAttrs.src}/pdftk.1 $out/share/man/man1
  '';

  meta.sourceProvenance = with lib.sourceTypes; [
    fromSource
    binaryBytecode # mitm cache
  ];
})
```

To update (or initialize) dependencies, run the update script via
something like `$(nix-build -A <pname>.mitmCache.updateScript)`
(`nix-build` builds the `updateScript`, `$(...)` runs the script at the
path printed by `nix-build`).

If your package can't be evaluated using a simple `pkgs.<pname>`
expression (for example, if your package isn't located in nixpkgs, or if
you want to override some of its attributes), you will usually have to
pass `pkg` instead of `pname` to `gradle.fetchDeps`. There are two ways
of doing so.

The first is to add the derivation arguments required for getting the
package. Using the pdftk example above:

```nix
{
  lib,
  stdenv,
  gradle,
  # ...
  pdftk,
}:

stdenv.mkDerivation (finalAttrs: {
  # ...
  mitmCache = gradle.fetchDeps {
    pkg = pdftk;
    data = ./deps.json;
  };
})
```

This allows you to `override` any arguments of the `pkg` used for the update script (for example, `pkg = pdftk.override { enableSomeFlag = true };)`.

The second is to use `finalAttrs.finalPackage` like this:

```nix
stdenv.mkDerivation (finalAttrs: {
  # ...
  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };
})
```
The limitation of this method is that you cannot override the `pkg` derivations's arguments.

In the former case, the update script will stay the same even if the derivation is called with different arguments. In the latter case, the update script will change depending on the derivation arguments. It's up to you to decide which one would work best for your derivation.

## Update Script {#gradle-update-script}

The update script does the following:

- Build the derivation's source via `pkgs.srcOnly`
- Enter a `nix-shell` for the derivation in a `bwrap` sandbox (the
  sandbox is only used on Linux)
- Set the `IN_GRADLE_UPDATE_DEPS` environment variable to `1`
- Run the derivation's `unpackPhase`, `patchPhase`, `configurePhase`
- Run the derivation's `gradleUpdateScript` (the Gradle setup hook sets
  a default value for it, which runs `preBuild`, `preGradleUpdate`
  hooks, fetches the dependencies using `gradleUpdateTask`, and finally
  runs the `postGradleUpdate` hook)
- Finally, store all of the fetched files' hashes in the lockfile. They
  may be `.jar`/`.pom` files from Maven repositories, or they may be
  files otherwise used for building the package.

`fetchDeps` takes the following arguments:

- `attrPath` - the path to the package in nixpkgs (for example,
  `"javaPackages.openjfx25"`). Used for update script metadata.
- `pname` - an alias for `attrPath` for convenience. This is what you
  will generally use instead of `pkg` or `attrPath`.
- `pkg` - the package to be used for fetching the dependencies. Defaults
  to `getAttrFromPath (splitString "." attrPath) pkgs`.
- `bwrapFlags` - allows you to override bwrap flags (only relevant for
  downstream, non-nixpkgs projects)
- `data` - path to the dependencies lockfile (can be relative to the
  package, can be absolute). In nixpkgs, it's discouraged to have the
  lockfiles be named anything other `deps.json`, consider creating
  subdirectories if your package requires multiple `deps.json` files.

## Environment {#gradle-environment}

The Gradle setup hook accepts the following environment variables:

- `mitmCache` - the MITM proxy cache imported using `gradle.fetchDeps`
- `gradleFlags` - command-line flags to be used for every Gradle
  invocation (this simply registers a function that uses the necessary
  flags).
  - You can't use `gradleFlags` for flags that contain spaces, in that
    case you must add `gradleFlagsArray+=("-flag with spaces")` to the
    derivation's bash code instead.
  - If you want to build the package using a specific Java version, you
    can pass `"-Dorg.gradle.java.home=${jdk}"` as one of the flags.
- `gradleBuildTask` - the Gradle task (or tasks) to be used for building
  the package. Defaults to `assemble`.
- `gradleCheckTask` - the Gradle task (or tasks) to be used for checking
  the package if `doCheck` is set to `true`. Defaults to `test`.
- `gradleUpdateTask` - the Gradle task (or tasks) to be used for
  fetching all of the package's dependencies in
  `mitmCache.updateScript`. Defaults to `nixDownloadDeps`.
- `gradleUpdateScript` - the code to run for fetching all of the
  package's dependencies in `mitmCache.updateScript`. Defaults to
  running the `preBuild` and `preGradleUpdate` hooks, running the
  `gradleUpdateTask`, and finally running the `postGradleUpdate` hook.
- `gradleInitScript` - path to the `--init-script` to pass to Gradle. By
  default, a simple init script that enables reproducible archive
  creation is used.
  - Note that reproducible archives might break some builds. One example
    of an error caused by it is `Could not create task ':jar'. Replacing
    an existing task that may have already been used by other plugins is
    not supported`. If you get such an error, the easiest "fix" is
    disabling reproducible archives altogether by setting
    `gradleInitScript` to something like `writeText
    "empty-init-script.gradle" ""`
- `enableParallelBuilding` / `enableParallelChecking` /
  `enableParallelUpdating` - pass `--parallel` to Gradle in the
  build/check phase or in the update script. Defaults to true. If the
  build fails for mysterious reasons, consider setting this to false.
- `dontUseGradleConfigure` / `dontUseGradleBuild` / `dontUseGradleCheck`
  \- force disable the Gradle setup hook for certain phases.
  - Note that if you disable the configure hook, you may face issues
    such as `Failed to load native library 'libnative-platform.so'`,
    because the configure hook is responsible for initializing Gradle.
