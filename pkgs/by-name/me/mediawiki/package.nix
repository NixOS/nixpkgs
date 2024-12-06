{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mediawiki";
  version = "1.44.2";

  src = fetchurl {
    url = "https://releases.wikimedia.org/mediawiki/${lib.versions.majorMinor version}/mediawiki-${version}.tar.gz";
    hash = "sha256-59cCZpeWcfr9A3BeF6IfGFvRsoP/hD7XL+KQ6G+sQzE=";
  };

  postPatch = ''
    substituteInPlace includes/installer/CliInstaller.php \
      --replace-fail '$vars = Installer::getExistingLocalSettings();' '$vars = null;'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mediawiki
    cp -r * $out/share/mediawiki
    echo "<?php
      return require(getenv('MEDIAWIKI_CONFIG'));
    ?>" > $out/share/mediawiki/LocalSettings.php

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests.mediawiki) mysql postgresql;
  };

  meta = with lib; {
    description = "Collaborative editing software that runs Wikipedia";
    license = licenses.gpl2Plus;
    homepage = "https://www.mediawiki.org/";
    platforms = platforms.all;
    teams = [ teams.c3d2 ];
  };
}
