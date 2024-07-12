# Gradle {#gradle}

Gradle is a popular build tool for Java/Kotlin. Gradle itself doesn't
currently provide tools to make dependency resolution reproducible, so
nixpkgs has a proxy designed for intercepting Gradle web requests to
record dependencies so they can be restored in a reproducible fashion.

## Building a Gradle package {#building-a-gradle-package}

A simple case is when the package doesn't have any dependencies. In that
case, simply adding `gradle` to `nativeBuildInputs` may be enough:

```nix
stdenv.mkDerivation {
  pname = "jextract";
  version = "unstable-2023-11-27";

  src = fetchFromGitHub {
    owner = "openjdk";
    repo = "jextract";
    rev = "8730fcf05c229d035b0db52ee6bd82622e9d03e9";
    hash = "sha256-Wct/yx5C0EjDtDyXNYDH5LRmrfq7islXbPVIGBR6x5Y=";
  };

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  gradleFlags = [
    "-Pllvm_home=${llvmPackages.libclang.lib}"
    "-Pjdk21_home=${jdk21}"
  ];

  doCheck = true;

  gradleCheckTask = "verify";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/path/to/jextract
    cp -r ./build/jextract/* $out/path/to/jextract/

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper "$out/path/to/jextract/bin/jextract" "$out/bin/jextract"
  '';
}
```

However, most of the time the package does have dependencies. In that
case, you will have to use the man-in-the-middle proxy.

First, add a dependencies update script:

```nix
# this will use `pkgs.jextract` as the package to update deps for
passthru.updateDeps = gradle.updateDeps { pname = "jextract"; };
```

Then run the update script via something like
`$(nix-build -A <pname>.updateDeps)` (`nix-build` builds the
`updateDeps` script, `$(...)` runs the script at the path printed by
`nix-build`). It will generate `deps.json` in your package directory.
You can then import it:

```nix
stdenv.mkDerivation {
  # ...
  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  # required for using mitm-cache on Darwin
  __darwinAllowLocalNetworking = true;
  # ...
}
```

If your package can't be evaluated using a simple `pkgs.<pname>`
expression (for example, if your package isn't located in nixpkgs, or if
you want to override some of its attributes), you must pass the `pkg`
instead of `pname` to `gradle.updateDeps`. There are two ways of doing
it.

The first is to add the derivation arguments required for getting the
package. Using the jextract example above:

```nix
{ lib
, stdenv
# ...
, jextract
}:

stdenv.mkDerivation {
  pname = "jextract";
  # ...
  passthru.updateDeps = gradle.updateDeps { pkg = jextract; };
}
```

This allows you to `override` any arguments of the `pkg` used for
`updateDeps` (for example, `pkg = jextract.override { enableSomeFlag =
true };`), so this is the preferred way.

The second is to create a `let` binding for the package, like this:

```nix
let self = stdenv.mkDerivation {
  # ...
  passthru.updateDeps = gradle.updateDeps { pkg = self; };
}; in self
```

This is useful if you can't easily pass the derivation as its own
argument, or if your `mkDerivation` is responsible for building multiple
packages.

In the former case, the update script will stay the same even if the
derivation is called with different arguments. In the latter case, the
update script will change depending on the derivation arguments. It's up
to you to decide which one would work best for your derivation.

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

`updateDeps` takes the following arguments:

- `attrPath` - the path to the package in nixpkgs (for example,
  `"javaPackages.openjfx22"`). Used for update script metadata.
- `pname` - an alias for `attrPath` for convenience. This is what you
  will generally use instead of `pkg` or `attrPath`.
- `pkg` - the package to be used for fetching the dependencies. Defaults
  to `getAttrFromPath (splitString "." attrPath) pkgs`.
- `bwrapFlags` - allows you to override bwrap flags (only relevant for
  downstream, non-nixpkgs projects)
- `depsPath` - path to the dependencies lockfile (can be relative to the
  package, can be absolute). Defaults to `"deps.json"`. The use of this
  attribute is discouraged for nixpkgs, consider creating subdirectories
  if your package requires multiple `deps.json` files.

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
  fetching all of the package's dependencies in `gradle.updateDeps`.
  Defaults to `nixDownloadDeps`.
- `gradleUpdateScript` - the code to run for fetching all of the
  package's dependencies in `gradle.updateDeps`. Defaults to running the
  `preBuild` and `preGradleUpdate` hooks, running the
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
