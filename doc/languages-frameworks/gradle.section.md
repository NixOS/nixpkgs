# Gradle {#gradle}

Gradle is a popular build tool for Java/Kotlin. Unfortunately, despites
its ubiquity, it has many poor design decisions. Because Gradle itself
doesn't offer reproduced builds in any meaningful way, nixpkgs has a
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

  gradleFlags = [
    "-Pllvm_home=${llvmPackages.libclang.lib}"
    "-Pjdk21_home=${jdk21}"
  ];

  doCheck = true;

  gradleCheckTask = "verify";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/
    cp -r ./build/jextract $out/opt/jextract

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper "$out/opt/jextract/bin/jextract" "$out/bin/jextract"
  '';

  meta = with lib; {
    description = "A tool which mechanically generates Java bindings from a native library headers";
    homepage = "https://github.com/openjdk/jextract";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ sharzy ];
  };
}
```

However, most of the time the package does have dependencies. In that
case, you will have to use the man-in-the-middle proxy.

First, add a dependencies update script:

```nix
passthru.updateDeps = gradle.updateDeps { inherit pname; };
```

Then, build the update script via `nix-build -A <pname>.updateDeps` and
run it via `./result`. It will generate `deps.json` in your package
directory. You can then import it:

```gradle
mitmCache = gradle.fetchDeps {
  inherit pname;
  data = ./deps.json;
};
```

## Update Script {#gradle-update-script}

The update script flow:

- Run the derivation's unpack, patch and configure phases
- Copy the result to the Nix store, alongside the Gradle flags (if set)
  and `preBuild`
- Copy it from the Nix store to an `nsjail` sandbox with networking
  enabled
- Run `preBuild` in the nsjail sandbox
- Run the `preBuild` that was passed as an argument to `updateDeps`
- Run `gradleCommands`, which defaults to `gradle nixDownloadDeps`
- Run the `postBuild` that was passed as an argument to `updateDeps`

`updateDeps` takes the following arguments:

- `attrPath` - a way to get to the package attr in nixpkgs, usually this
  is the package name
- `pname` - an alias for `attrPath`, for convenience. This should only
  be used when `attrPath` matches `pname`
- `code` - allows you to completely override the Nix code used to
  evaluate the package (only relevant for downstream, non-nixpkgs
  projects)
- `attrOverrides` - allows you to override certain attributes of the
  derivation that will be used for copying the source from
- `preBuild` / `postBuild` - run these commands before/after fetching
  dependencies
- `gradleCommands` - run these commands to fetch the dependencies
- `depsPath` - path to the dependencies lockfile relative to the
  package. Defaults to `deps.json`.
- `availablePackages` - packages that will be available in the nsjail
  sandbox. By default, no extra packages will be available, which is
  enough for nearly all packages. For example, the MITM proxy supports
  intercepting `curl` and `wget` traffic, so if the Gradle build script
  requires them, you may add them here.

## Environment {#gradle-environment}

The Gradle setup hook accepts the following environment variables:

- `mitmCache` - the MITM proxy cache imported using `gradle.fetchDeps`
- `mitmCachePort` - the MITM proxy port to be used (defaults to 1337)
- `gradleFlags` - command-line flags to be used for every Gradle
  invocation (this simply registers a function that uses the necessary
  flags).
  - You can't use `gradleFlags` for flags that contain spaces, in that
    case you must add `gradleFlagsArray+=("-flag with spaces")` to the
    derivation's bash code instead.
- `gradleBuildTask` - the Gradle task to be used for building the
  package. Defaults to `assemble`.
- `gradleCheckTask` - the Gradle task to be used for checking the
  package if `doCheck` is set to `true`. Defaults to `test`.
- `enableParallelBuilding` / `enableParallelChecking` - pass
  `--parallel` to Gradle in the build/check phase
- `dontUseGradleConfigure` / `dontUseGradleBuild` / `dontUseGradleCheck`
  \- forcefully disable the Gradle setup hook for certain phases.

