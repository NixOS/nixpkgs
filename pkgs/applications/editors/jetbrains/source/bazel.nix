{
  bazel_8,
  callPackage,
  lib,
  fetchzip,
  fetchFromGitHub,
}:
let
  bazelBaseVersion = "8.4.2";
  bazelBaseHash = "sha256-5oNYKHPaDkpunl6oC104Rh1wAEMWfLfvCFdGHlXZn4o=";

  bazelPatchesVersion = "${bazelBaseVersion}-jb_20251027_92";
  bazelPatchesHash = "sha256-13TD+Wv6qaVIAMy6okb7H1FrPu3zBloHXRuQ2Qe7X50=";
  bazelPatchesSrc = (
    fetchFromGitHub {
      owner = "jetbrains";
      repo = "bazel";
      rev = bazelPatchesVersion;
      hash = bazelPatchesHash;
    }
  );
  # These patches asume the raw git sources of Bazel are used for compiling. However we use the dist sources,
  # since compiling from the raw sources is a pain. This means some patches aren't relevant to us at this stage.
  bazelPatchesNames = [
    "0001-DRAFT-follow-307-temporary-redirect-in-HttpDownloadH.patch"
    "0002-DRAFT-ignore-credentials-in-favor-of-authorization-f.patch"
    "0003-DRAFT-pass-remote-cache-headers-to-HttpCacheClient-i.patch"
    "0004-DRAFT-fallback-to-USERPROFILE-environment-variable-w.patch"
    "0007-DRAFT-add-zstd-to-accept-encoding-in-HttpDownloadHan.patch"
    "0009-DRAFT-use-recursive-file-watcher-on-Windows-in-Watch.patch"
    "0010-DRAFT-check-junctions-by-is-other-in-WindowsFileSyst.patch"
    "0011-DRAFT-make-last-change-time-lazy-in-WindowsFileSyste.patch"
    "0012-DRAFT-add-WindowsFileSystem-readdir-to-traverse-entr.patch"
    "0013-DRAFT-switch-to-jbrsdk-v25b176.4.patch"
    "0014-DRAFT-switch-back-to-zulu-v21.40.17-on-windows-arm64.patch"
    #"0015-Allow-platform-specific-startup-bazelrc-flags.patch"
  ];
in
(bazel_8.override { version = "${bazelPatchesVersion}"; }).overrideAttrs (
  finalAttrs: oldAttrs: {
    src = fetchzip {
      url = "https://github.com/bazelbuild/bazel/releases/download/${bazelBaseVersion}/bazel-${bazelBaseVersion}-dist.zip";
      hash = bazelBaseHash;
      stripRoot = false;
    };
    # add jb patches
    patches =
      (oldAttrs.patches or [ ]) ++ (lib.map (v: "${bazelPatchesSrc}/patches/" + v) bazelPatchesNames);

    passthru = (oldAttrs.passthru or { }) // {
      # Currently not available through top-level - is potentially pending to be rolled back into `buildBazelPackage`.
      package = callPackage ../../../../by-name/ba/bazel_8/build-support/bazelPackage.nix { };
      derivation = callPackage ../../../../by-name/ba/bazel_8/build-support/bazelDerivation.nix { };
    };
  }
)
