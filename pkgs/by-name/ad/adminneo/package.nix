{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  php,
  writeText,
  nix-update-script,
  theme ? null,
  plugins ? [ ],
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adminneo";
  version = "4.17";

  src = fetchFromGitHub {
    owner = "adminneo-org";
    repo = "adminneo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WVNeox5xygQjD5ekmcwZX9AnfhBq6YpHBLC2+WZJzvI=";
  };

  nativeBuildInputs = [
    php
  ];

  buildPhase = ''
    runHook preBuild

    php compile.php

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp export/adminer-${finalAttrs.version}.php $out/adminer.php
    cp ${./index.php} $out/index.php

    ${lib.optionalString (theme != null) ''
      cp designs/${theme}/adminer.css $out/adminer.css
    ''}

    # Copy base plugin
    mkdir -p $out/plugins
    cp plugins/plugin.php $out/plugins/plugin.php

    ${lib.optionalString (plugins != [ ]) ''
      cp plugins/*.php $out/plugins/
      cp ${writeText "$out/plugins.json" ''
        ${toString (builtins.toJSON plugins)}
      ''} $out/plugins.json
    ''}

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    indexPHP = ./index.php;
  };

  meta = {
    description = "Database management in a single PHP file (fork of Adminer)";
    homepage = "https://github.com/adminneo-org/adminneo";
    license = with lib.licenses; [
      asl20
      gpl2Only
    ];
    maintainers = with lib.maintainers; [
      johnrtitor
    ];
    platforms = lib.platforms.all;
  };
})
