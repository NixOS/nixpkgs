# Bazel {#sec-bazel}

Several versions of Bazel are available in nixpkgs:

 - Bazel 6 (`bazel_6`)
 - Bazel 5 (`bazel_5`)
 - Bazel 4 (`bazel_4`)
 - Bazel 3 (`bazel`)

## buildBazelPackage {#sec-bazel-build-bazel-package}

The function `buildBazelPackage` helps with building many Bazel-based projects. It splits the build process into two derivations, a fetcher fixed-output derivation and a builder derivation. The fetcher downloads all external dependencies needed to build `bazelTarget` and `bazelTestTargets`, and the builder uses the fetched dependencies to build `bazelTarget` and test `bazelTestTargets`.

### Example {#sec-bazel-build-bazel-package-example}

```nix
{ buildBazelPackage, bazel_6, jdk11, fetchFromGitHub }:
buildBazelPackage rec {
    pname = "bazel-cxx-hello-world";
    version = "a8a6d0a65c31d3b37f7d718382c2f920808ec59b";
    src = fetchFromGitHub {
        owner = "piperswe";
        repo = pname;
        rev = version;
    };
    nativeBuildInputs = [
        jdk11
    ];

    # Required: Choose the Bazel version - there is no default.
    bazel = bazel_6;
    # Required: Which target should be built?
    bazelTarget = "//src:hello";
    # Optional: Targets to be tested in checkPhase
    bazelTestTargets = ["//..."];
    # Required: Additional attrs to be added to the builder derivation
    buildAttrs = {
        installPhase = ''
            install -Dm755 bazel-bin/src/hello $out/bin/hello
        '';
    };
    # Required: Additional attrs to be added to the fetcher derivation
    fetchAttrs = {
        # Required: The output hash of the fetch fixed-output derivation
        sha256 = "sha256-/iwPwtJBOboujFZHU5WJJAo7Z3/8l/SbBQWBxUmY+Jw=";
    };
}
```
