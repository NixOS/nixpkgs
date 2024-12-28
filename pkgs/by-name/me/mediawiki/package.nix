{ lib, stdenvNoCC, fetchurl, imagemagick, nixosTests }:

stdenvNoCC.mkDerivation rec {
  pname = "mediawiki";
  version = "1.42.4";

  src = fetchurl {
    url = "https://releases.wikimedia.org/mediawiki/${lib.versions.majorMinor version}/mediawiki-${version}.tar.gz";
    hash = "sha256-jiCXmH1Nu6fASFP2LNo338M4GeACjKSALSXzRM/o5yc=";
  };

  postPatch = ''
    sed -i 's|$vars = Installer::getExistingLocalSettings();|$vars = null;|' includes/installer/CliInstaller.php

    # fix generating previews for SVGs
    substituteInPlace includes/config-schema.php \
      --replace-fail "\$path/convert" "${imagemagick}/bin/convert"
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
    maintainers = with maintainers; [ ] ++ teams.c3d2.members;
  };
}
