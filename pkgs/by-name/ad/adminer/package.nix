{
  lib,
  stdenv,
  fetchurl,
  php,
  nix-update-script,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "adminer";
  version = "5.4.1";

  # not using fetchFromGitHub as the git repo relies on submodules that are included in the tar file
  src = fetchurl {
    url = "https://github.com/vrana/adminer/releases/download/v${finalAttrs.version}/adminer-${finalAttrs.version}.zip";
    hash = "sha256-+Ki46mR+E82F/spU0DBM7kWelY3zA9bdFad44HeZ5Lo=";
  };

  nativeBuildInputs = [
    php
    php.packages.composer
    unzip
  ];

  buildPhase = ''
    runHook preBuild

    composer --no-cache run compile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp adminer-${finalAttrs.version}.php $out/adminer.php

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Database management in a single PHP file";
    homepage = "https://www.adminer.org";
    license = with lib.licenses; [
      asl20
      gpl2Only
    ];
    maintainers = with lib.maintainers; [
      jtojnar
      sstef
    ];
    platforms = lib.platforms.all;
  };
})
