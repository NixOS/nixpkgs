{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "limesurvey";
  version = "6.16.4+260113";

  src = fetchFromGitHub {
    owner = "LimeSurvey";
    repo = "LimeSurvey";
    tag = version;
    hash = "sha256-RE7rM19LW2mNnNMn3Yw0QWgD6Tm5p9fityCGqz1Te/o=";
  };

  phpConfig = writeText "config.php" ''
    <?php
      return require(getenv('LIMESURVEY_CONFIG'));
    ?>
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/limesurvey
    cp -r . $out/share/limesurvey
    cp ${phpConfig} $out/share/limesurvey/application/config/config.php

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) limesurvey; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open source survey application";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.limesurvey.org";
    maintainers = with lib.maintainers; [ offline ];
    platforms = with lib.platforms; unix;
  };
}
