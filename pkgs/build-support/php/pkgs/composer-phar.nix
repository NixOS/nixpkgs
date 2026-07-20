{
  _7zz,
  curl,
  fetchurl,
  git,
  lib,
  makeBinaryWrapper,
  php,
  stdenvNoCC,
  unzip,
  xz,
  version,
  pharHash,
  installShellFiles,
  stdenv,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "composer-phar";
  inherit version;

  src = fetchurl {
    url = "https://github.com/composer/composer/releases/download/${finalAttrs.version}/composer.phar";
    hash = pharHash;
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -D $src $out/libexec/composer/composer.phar
    makeWrapper ${lib.getExe php} $out/bin/composer \
      --add-flags "$out/libexec/composer/composer.phar" \
      --prefix PATH : ${
        lib.makeBinPath [
          _7zz
          curl
          git
          unzip
          xz
        ]
      }

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd composer \
      --bash <($out/bin/composer completion bash)
  '';

  meta = {
    changelog = "https://github.com/composer/composer/releases/tag/${finalAttrs.version}";
    description = "Dependency Manager for PHP, shipped from the PHAR file";
    homepage = "https://getcomposer.org/";
    license = lib.licenses.mit;
    mainProgram = "composer";
    maintainers = [ lib.maintainers.patka ];
    teams = [ lib.teams.php ];
    platforms = lib.platforms.all;
  };
})
