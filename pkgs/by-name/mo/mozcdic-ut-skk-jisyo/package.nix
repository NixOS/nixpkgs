{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-skk-jisyo";
  version = "0-unstable-2024-10-12";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-skk-jisyo";
    rev = "f34f5801b1f29cff34633e4a03b887702f98ed54";
    hash = "sha256-W5ZZDSKvN5fLsFyrEKGMQl/S4q9WGLmewPqofztOPe0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-skk-jisyo.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Mozc UT SKK-JISYO Dictionary is a dictionary converted from SKK-JISYO for Mozc.";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-sudachidict";
    license = with lib.licenses; [
      asl20
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
