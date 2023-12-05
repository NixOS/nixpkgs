# Gradle {#gradle}

Gradle is a popular build tool for Java/Kotlin. Unfortunately, despite
its ubiquity, it has many poor design decisions. Because Gradle itself
doesn't offer reproducible builds in any meaningful way, nixpkgs has a
man-in-the-middle-proxy designed for intercepting Gradle web requests.

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

  # required for building Gradle packages for Darwin
  __darwinAllowLocalNetworking = true;

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
mitmCache = gradle.fetchDeps {
  inherit pname;
  data = ./deps.json;
};
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

## Update Script {#gradle-update-script}

The update script flow:

- Build the derivation's source via `pkgs.srcOnly`
- Enter a `nix-shell` for the derivation in an `nsjail` sandbox (the
  sandbox is only used on Linux)
- Set the `IN_GRADLE_UPDATE_DEPS` environment variable to `1`
- Run the derivation's `unpack`, `patch`, `configure` phases
- Run the derivation's `preBuild`
- Run the `preBuild` that was passed as an argument to `updateDeps`
- Run `script`, which defaults to `gradle nixDownloadDeps`
- Run the `postBuild` that was passed as an argument to `updateDeps`
- Finally, store all of the fetched files' hashes in the lockfile. They
  may be `.jar`/`.pom` from Maven repositories, or they may be files
  otherwise used for building the package.

`updateDeps` takes the following arguments:

- `attrPath` - the path to the package in nixpkgs (for example,
  `"javaPackages.openjfx22"`). Used for update script metadata.
- `pname` - an alias for `attrPath` for convenience. This is what you
  will generally use instead of `pkg` or `attrPath`.
- `pkg` - the package to be used for fetching the dependencies. Defaults
  to `getAttrFromPath (splitString "." attrPath) pkgs`.
- `nsjailFlags` - allows you to override nsjail flags (only relevant for
  downstream, non-nixpkgs projects)
- `preBuild` / `postBuild` - run these commands before/after fetching
  dependencies
- `script` - run these commands to fetch the dependencies
- `depsPath` - path to the dependencies lockfile relative to the
  package. Defaults to `deps.json`. The use of this attribute is
  discouraged for nixpkgs, consider creating subdirectories if your
  package requires multiple `deps.json` files.

## Environment {#gradle-environment}

The Gradle setup hook accepts the following environment variables:

- `mitmCache` - the MITM proxy cache imported using `gradle.fetchDeps`
- `gradleFlags` - command-line flags to be used for every Gradle
  invocation (this simply registers a function that uses the necessary
  flags).
  - You can't use `gradleFlags` for flags that contain spaces, in that
    case you must add `gradleFlagsArray+=("-flag with spaces")` to the
    derivation's bash code instead. It's recommended to use the
    configure phase for this (e.g. `preConfigure`) or any earlier phase,
    so the update script can use the same Gradle flags as the
    derivation.
- `gradleBuildTask` - the Gradle task to be used for building the
  package. Defaults to `assemble`.
- `gradleCheckTask` - the Gradle task to be used for checking the
  package if `doCheck` is set to `true`. Defaults to `test`.
- `enableParallelBuilding` / `enableParallelChecking` - pass
  `--parallel` to Gradle in the build/check phase
- `dontUseGradleConfigure` / `dontUseGradleBuild` / `dontUseGradleCheck`
  \- forcefully disable the Gradle setup hook for certain phases.

