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
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "adminneo-org";
    repo = "adminneo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8A+sCojrtwsQdsJck1Cy1UBl8gFhuvsWq2ISbVkhh0Q=";
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
