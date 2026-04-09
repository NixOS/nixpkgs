{
  bazel_8,
  callPackage,
  fetchFromGitHub,
  fetchzip,
  lib,
}:
{
  base,
  jbPatches,
}:
let
  bazelPatchesVersion = "${base.version}-${jbPatches.version}";
  bazelPatchesSrc = (
    fetchFromGitHub {
      owner = "jetbrains";
      repo = "bazel";
      rev = bazelPatchesVersion;
      hash = jbPatches.hash;
    }
  );
in
(bazel_8.override { version = "${bazelPatchesVersion}"; }).overrideAttrs (
  finalAttrs: oldAttrs: {
    src = fetchzip {
      url = "https://github.com/bazelbuild/bazel/releases/download/${base.version}/bazel-${base.version}-dist.zip";
      hash = base.hash;
      stripRoot = false;
    };
    # add jb patches
    patches =
      (oldAttrs.patches or [ ]) ++ (lib.map (v: "${bazelPatchesSrc}/patches/" + v) jbPatches.names);

    passthru = (oldAttrs.passthru or { }) // {
      # Currently not available through top-level - is potentially pending to be rolled back into `buildBazelPackage`.
      package = callPackage ../../../../by-name/ba/bazel_8/build-support/bazelPackage.nix { };
      derivation = callPackage ../../../../by-name/ba/bazel_8/build-support/bazelDerivation.nix { };
      addFilePatch =
        (callPackage ../../../../by-name/ba/bazel_8/build-support/patching.nix { }).addFilePatch;
    };
  }
)
