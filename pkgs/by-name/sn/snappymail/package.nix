{
  lib,
  stdenv,
  fetchurl,
  writeText,
  dataPath ? "/var/lib/snappymail",
}:

stdenv.mkDerivation rec {
  pname = "snappymail";
  version = "3.0.1";

  src = fetchurl {
    url = "https://github.com/the-djmaze/snappymail/releases/download/v${version}/snappymail-${version}.tar.gz";
    sha256 = "sha256-bIHHGj6//7R1Vx0uvHTecJ8JdosMWNZqnAcy+RzLtII=";
  };

  sourceRoot = "snappymail";

  includeScript = writeText "include.php" ''
    <?php

    # the trailing `/` is important here
    define('APP_DATA_FOLDER_PATH', '${dataPath}/');
  '';

  installPhase = ''
    mkdir $out
    cp -r ../* $out
    rm -rf $out/{data,env-vars,_include.php}
    cp ${includeScript} $out/include.php
  '';

  meta = {
    description = "Simple, modern & fast web-based email client";
    homepage = "https://snappymail.eu";
    changelog = "https://github.com/the-djmaze/snappymail/blob/v${version}/CHANGELOG.md";
    downloadPage = "https://github.com/the-djmaze/snappymail/releases";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
