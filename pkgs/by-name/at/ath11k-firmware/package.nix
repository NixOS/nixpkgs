{
  lib,
  fetchFromGitLab,
  qca-swiss-army-knife,
  stdenvNoCC,
  nix-update-script,
}:

let
  mkAthFirmware =
    {
      athVersion,
      rev,
      hash,
      updateFilename,
      position ? null,
    }:

    stdenvNoCC.mkDerivation (finalPackage: {
      pname = "${athVersion}-firmware";
      version = lib.substring 0 8 finalPackage.src.rev;
      inherit athVersion;
      src = fetchFromGitLab {
        domain = "git.codelinaro.org";
        owner = "clo/ath-firmware";
        repo = "${athVersion}-firmware";
        inherit rev hash;
      };

      nativeBuildInputs = [ qca-swiss-army-knife ];

      dontBuild = true;
      dontInstall = true;
      doDist = true;

      distPhase = ''
        runHook preDist
        mkdir -p $out/lib/firmware/$athVersion
        touch $out/lib/firmware/WHENCE
        $athVersion-fw-repo --install $out/lib/firmware
        if [ ! -s $out/lib/firmware/WHENCE ]; then
          rm -f $out/lib/firmware/WHENCE
        fi
        runHook postDist
      '';

      passthru = {
        inherit mkAthFirmware;
        updateScript = nix-update-script {
          extraArgs = [
            "--version=branch=main"
            "--override-filename"
            updateFilename
          ];
        };
      };

      meta =
        {
          description = "Firmware for ${athVersion} wireless chipsets, maintained by Linaro";
          homepage = "https://git.codelinaro.org/clo/ath-firmware/${athVersion}-firmware";
          license = lib.licenses.unfreeRedistributableFirmware;
          maintainers = with lib.maintainers; [ numinit ];
          platforms = with lib.platforms; linux;
        }
        // lib.optionalAttrs (position != null) {
          inherit position;
        };
    });

in
mkAthFirmware {
  athVersion = "ath11k";
  rev = "1e7cd757828d414f71da82f480696540473bd475";
  hash = "sha256-QXZHcbMNX0f2RQBrCCYRS3dLU1q/02J3HjnWuv8Oaaw=";
  updateFilename = ./package.nix;
}
