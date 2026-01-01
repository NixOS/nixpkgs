{
  lib,
  stdenvNoCC,
  fetchurl,
<<<<<<< HEAD
=======
  imagemagick,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mediawiki";
<<<<<<< HEAD
  version = "1.45.0";

  src = fetchurl {
    url = "https://releases.wikimedia.org/mediawiki/${lib.versions.majorMinor version}/mediawiki-${version}.tar.gz";
    hash = "sha256-1Jm8frPXGDXCvsHJyu2IoDCK7DfwcmTnURDSor7wJTQ=";
  };

  postPatch = ''
    substituteInPlace includes/installer/CliInstaller.php \
      --replace-fail '$vars = Installer::getExistingLocalSettings();' '$vars = null;'
=======
  version = "1.44.2";

  src = fetchurl {
    url = "https://releases.wikimedia.org/mediawiki/${lib.versions.majorMinor version}/mediawiki-${version}.tar.gz";
    hash = "sha256-59cCZpeWcfr9A3BeF6IfGFvRsoP/hD7XL+KQ6G+sQzE=";
  };

  postPatch = ''
    sed -i 's|$vars = Installer::getExistingLocalSettings();|$vars = null;|' includes/installer/CliInstaller.php

    # fix generating previews for SVGs
    substituteInPlace includes/config-schema.php \
      --replace-fail "\$path/convert" "${imagemagick}/bin/convert"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Collaborative editing software that runs Wikipedia";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.mediawiki.org/";
    platforms = lib.platforms.all;
    teams = [ lib.teams.c3d2 ];
=======
  meta = with lib; {
    description = "Collaborative editing software that runs Wikipedia";
    license = licenses.gpl2Plus;
    homepage = "https://www.mediawiki.org/";
    platforms = platforms.all;
    teams = [ teams.c3d2 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
