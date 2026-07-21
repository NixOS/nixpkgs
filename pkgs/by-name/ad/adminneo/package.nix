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
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "adminneo-org";
    repo = "adminneo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vnvLRPMiVuSEAQJSPBGM63LppQ7pZv6ZaQnUTpUw9W0=";
  };

  nativeBuildInputs = [
    php
  ];

  makeFlags = [
    "PHP=${php}/bin/php"
  ];

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
