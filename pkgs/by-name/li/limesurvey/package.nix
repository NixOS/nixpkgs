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
  version = "6.15.14+250924";

  src = fetchFromGitHub {
    owner = "LimeSurvey";
    repo = "LimeSurvey";
    tag = version;
    hash = "sha256-xxK6JEgeBVIj8CGb0qSzwfO1Se9+jMtGB9V3rsc9bBU=";
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

  meta = with lib; {
    description = "Open source survey application";
    license = licenses.gpl2Plus;
    homepage = "https://www.limesurvey.org";
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; unix;
  };
}
