{
  lib,
  stdenvNoCC,
  fetchpatch,
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

  patches = [
    # Fix installation with postgres
    (fetchpatch {
      url = "https://gerrit.wikimedia.org/r/changes/mediawiki%2Fcore~1231289/revisions/4/patch?download";
      decode = "base64 -d";
      postFetch = ''
        substituteInPlace $out \
          --replace "/Installer/" "/installer/"
      '';
      hash = "sha256-bhfw5CW4EEpr2GTGda3va+EmM/vK6AqBfyoCcsSiqNQ=";
    })
  ];

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
    maintainers = with lib.maintainers; [
      # for the C3D2
      SuperSandro2000
    ];
  };
}
