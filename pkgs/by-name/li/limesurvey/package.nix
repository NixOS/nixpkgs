{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "limesurvey";
  version = "6.6.5+240924";

  src = fetchFromGitHub {
    owner = "LimeSurvey";
    repo = "LimeSurvey";
    rev = version;
    hash = "sha256-CuuTFCDY7jnF2njZdyB6e8/nRf0n0ybKgZ0QscC2IAI=";
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

  passthru.tests = {
    smoke-test = nixosTests.limesurvey;
  };

  meta = with lib; {
    description = "Open source survey application";
    license = licenses.gpl2Plus;
    homepage = "https://www.limesurvey.org";
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; unix;
  };
}
