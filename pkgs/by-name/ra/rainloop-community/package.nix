{
  lib,
  stdenv,
  fetchurl,
  unzip,
  writeText,
  dos2unix,
  dataPath ? "/var/lib/rainloop",
}:
stdenv.mkDerivation rec {
  pname = "rainloop-community";
  version = "1.16.0";

  nativeBuildInputs = [
    unzip
    dos2unix
  ];

  unpackPhase = ''
    mkdir rainloop
    unzip -q -d rainloop $src
  '';

  src = fetchurl {
    url = "https://github.com/RainLoop/rainloop-webmail/releases/download/v${version}/rainloop-community-${version}.zip";
    sha256 = "sha256-25ScQ2OwSKAuqg8GomqDhpebhzQZjCk57h6MxUNiymc=";
  };

  prePatch = ''
    dos2unix ./rainloop/rainloop/v/1.16.0/app/libraries/MailSo/Base/HtmlUtils.php
  '';

  patches = [
    ./fix-cve-2022-29360.patch
  ];

  postPatch = ''
    unix2dos ./rainloop/rainloop/v/1.16.0/app/libraries/MailSo/Base/HtmlUtils.php
  '';

  includeScript = writeText "include.php" ''
    <?php

    /**
     * @return string
     */
    function __get_custom_data_full_path()
    {
      $v = getenv('RAINLOOP_DATA_DIR', TRUE);
      return $v === FALSE ? '${dataPath}' : $v;
    }
  '';

  installPhase = ''
    mkdir $out
    cp -r rainloop/* $out
    rm -rf $out/data
    cp ${includeScript} $out/include.php
    mkdir $out/data
    chmod 700 $out/data
  '';

  meta = {
    description = "Simple, modern & fast web-based email client";
    homepage = "https://www.rainloop.net";
    downloadPage = "https://github.com/RainLoop/rainloop-webmail/releases";
    license = with lib.licenses; [ agpl3Only ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ das_j ];
  };
}
