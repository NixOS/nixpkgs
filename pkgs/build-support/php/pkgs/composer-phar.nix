{
  _7zz
  , cacert
  , curl
  , fetchurl
  , git
  , lib
  , makeBinaryWrapper
  , php
  , stdenvNoCC
  , unzip
  , xz
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "composer-phar";
  version = "2.6.3";

  src = fetchurl {
    url = "https://github.com/composer/composer/releases/download/${finalAttrs.version}/composer.phar";
    hash = "sha256-5Yo5DKwN9FzPWj2VrpT6I57e2LeQf6LI91LwIDBPybE=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D $src $out/libexec/composer/composer.phar
    makeWrapper ${php}/bin/php $out/bin/composer \
      --add-flags "$out/libexec/composer/composer.phar" \
      --prefix PATH : ${lib.makeBinPath [ _7zz cacert curl git unzip xz ]}

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP, shipped from the PHAR file";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
})
