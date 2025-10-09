{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  php,
  nix-update-script,
  installPlugins ? true,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adminneo";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "adminneo-org";
    repo = "adminneo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ckz0LvKLY6xm3thPmY/ry8G5kkt29rmDsG/D6NNeRoY=";
  };

  nativeBuildInputs = [
    php
  ];

  # Package provides a Makefile, which is currently broken
  # https://github.com/adminneo-org/adminneo/issues/161
  # As soon, as this is fixed, the buildPhase can be removed
  buildPhase = ''
    runHook preBuild

    ${php}/bin/php bin/compile.php

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp compiled/adminneo-${finalAttrs.version}.php $out/adminneo.php
    # for compatibility
    ln -s adminneo.php $out/index.php
  ''
  + (lib.optionalString installPlugins ''
    cp -r compiled/adminneo-plugins $out/
  '')
  + ''
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Database management in a single PHP file (fork of Adminer)";
    homepage = "https://www.adminneo.org/";
    license = with lib.licenses; [
      asl20
      gpl2Only
    ];
    maintainers = with lib.maintainers; [
      Necoro
    ];
    platforms = lib.platforms.all;
  };
})
