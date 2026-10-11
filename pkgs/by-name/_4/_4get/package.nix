{
  lib,
  stdenvNoCC,
  fetchFromGitea,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "4get";
  version = "0-unstable-2026-10-10";

  src = fetchFromGitea {
    domain = "git.lolcat.ca";
    owner = "lolcat";
    repo = "4get";
    rev = "836521b8d741ed22070310a2bf9218dde1daaec8";
    hash = "sha256-wqO2qxK9iQ3tV3luyPkmlCluCYQMW30/G9dUY+KaxXY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  postPatch = ''
        # Allow overriding configuration via FOURGET_CONFIG env var or /etc/4get/config.php
        mv data/config.php data/config.default.php
        substituteInPlace data/config.default.php \
          --replace-fail '<?php' '<?php if (!class_exists("default_config")) {' \
          --replace-fail 'class config{' 'class default_config{'
        echo "}" >> data/config.default.php

        cat << 'EOF' > data/config.php
    <?php
    require_once __DIR__ . "/config.default.php";

    if (($configFile = getenv('FOURGET_CONFIG')) && file_exists($configFile)) {
        require_once $configFile;
    } elseif (file_exists('/etc/4get/config.php')) {
        require_once '/etc/4get/config.php';
    } else {
        class config extends default_config {}
    }
    EOF
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r * "$out/"

    runHook postInstall
  '';

  meta = {
    description = "Privacy-respecting proxy search engine";
    homepage = "https://git.lolcat.ca/lolcat/4get";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ gs-101 ];
  };
})
