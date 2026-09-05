{
  lib,
  callPackage,
  curl,
  qt6Packages,
  stdenv,
}:

let
  baseVersion = "2026.2.1";
  build = "6";
  hashes = {
    x86_64-linux = "sha256-C51NrvavtJ3TUFIeUxynqgWZaTXf7tIRBj1r6mNkq5A=";
    aarch64-linux = "sha256-IvJhhW9Z6gqXwAPVwFnfs5YtEKp+SlZeQlMABzzVJ6k=";
  };
  version = "${baseVersion}.${build}";
  platform =
    {
      x86_64-linux = "linux-x86_64";
      aarch64-linux = "linux-sbsa";
    }
    .${stdenv.hostPlatform.system};
  hash = hashes.${stdenv.hostPlatform.system};
  arch =
    {
      x86_64-linux = "x64";
      aarch64-linux = "a64";
    }
    .${stdenv.hostPlatform.system};
  buildNsightCommon = callPackage ./common.nix;
in
(buildNsightCommon {
  pname = "nvidia-nsight-compute";
  inherit version hash;
  url = "https://developer.nvidia.com/downloads/assets/tools/secure/nsight-compute/${
    lib.strings.replaceString "." "_" baseVersion
  }/nsight_compute-${platform}-${version}.run";
  extraBuildInputs = [
    curl
    qt6Packages.qtcharts
  ];
}).overrideAttrs
  (
    finalAttrs: prevAttrs: {
      unpackPhase = ''
        runHook preUnpack
        sh ./installer.run --target . --noexec
        runHook postUnpack
      '';

      postInstall = ''
        # Remove platforms other than the host platform
        find $out/opt/target ! -name "target" ! -name "*-${arch}" -type d -exec rm -rf {} +

        # Patch ncu-ui so it doesn't LD_PRELOAD things from /lib64
        (cd $out/opt/host/linux-desktop-* && patch < ${./ncu-ui.patch})

        # Collides with other things
        mkdir -p $out/opt/shared/nvidia-nsight-compute-standalone
        mv $out/opt/EULA.txt $out/opt/shared/nvidia-nsight-compute-standalone/

        # Symlink the binaries under bin
        mkdir $out/bin
        ln -s $out/opt/ncu $out/bin/ncu
        ln -s $out/opt/ncu-ui $out/bin/ncu-ui
      '';

      passthru = {
        inherit buildNsightCommon;
      };

      meta = {
        description = "Nvidia Nsight Compute (standalone version)";
        homepage = "https://developer.nvidia.com/nsight-compute";
        license = lib.licenses.unfree;
        platforms = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      };
    }
  )
