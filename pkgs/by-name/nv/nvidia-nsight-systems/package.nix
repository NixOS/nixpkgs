{
  lib,
  stdenv,
  nvidia-nsight-compute,
}:
let
  baseVersion = "2026.3";
  build = "1.157-3804839";
  hashes = {
    x86_64-linux = "sha256-zI/Xt9+PatfdSPdN+REIRhCG1bBz9s/RGB3hTCi+Za8=";
    aarch64-linux = "sha256-JKSu30jPr8tiesbH2b7FwV5lhvKSdfK7/8PIcah8URU=";
  };
  version = "${baseVersion}.${build}";
  platform =
    {
      x86_64-linux = "linux";
      aarch64-linux = "linux-sbsa";
    }
    .${stdenv.hostPlatform.system};
  hash = hashes.${stdenv.hostPlatform.system};
in
(nvidia-nsight-compute.buildNsightCommon {
  pname = "nvidia-nsight-systems";
  inherit version hash;
  url = "https://developer.nvidia.com/downloads/assets/tools/secure/nsight-systems/${
    lib.strings.replaceString "." "_" baseVersion
  }/NsightSystems-${platform}-public-${version}.run";
}).overrideAttrs
  (
    finalAttrs: prevAttrs: {
      unpackPhase = ''
        runHook preUnpack
        # This fails for some non-obvious reason, but it doesn't seem to matter
        sh ./installer.run --accept --target . --noexec --keep || true
        runHook postUnpack
        chmod a-w  ./install-linux.pl
      '';

      postInstall = ''
        # Patch nsys-ui so it doesn't LD_PRELOAD things from /lib64
        (cd $out/opt/host-linux-* && patch < ${./nsys-ui.patch})

        # Collides with other things
        mkdir -p $out/opt/shared/nvidia-nsight-systems-standalone
        mv $out/opt/EULA.txt $out/opt/shared/nvidia-nsight-systems-standalone/

        ln -s $out/opt/bin $out/bin
      '';

      meta = {
        description = "Nvidia Nsight Systems (standalone version)";
        homepage = "https://developer.nvidia.com/nsight-systems";
        license = lib.licenses.unfree;
        platforms = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      };
    }
  )
