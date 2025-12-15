{
  lib,
  stdenvNoCC,
  fetchurl,
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mediawiki";
  version = "1.45.1";

  src = fetchurl {
    url = "https://releases.wikimedia.org/mediawiki/${lib.versions.majorMinor version}/mediawiki-${version}.tar.gz";
    hash = "sha256-4vEmsZrsQiBRoKUODGq36QTzOzmIpHudqK+/0MCiUsw=";
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

  meta = {
    description = "Collaborative editing software that runs Wikipedia";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.mediawiki.org/";
    platforms = lib.platforms.all;
    teams = [ lib.teams.c3d2 ];
  };
}
