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
  pname = "adminer-pematon";
  version = "4.12";

  src = fetchFromGitHub {
    owner = "pematon";
    repo = "adminer";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-ExCHEsZ+VFmrom3632/1OOjb3zbZgiaZJDapBkBGUnQ=";
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
    cp temp/adminer-${finalAttrs.version}.php $out/adminer.php
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
  };

  meta = {
    description = "Database management in a single PHP file (Pematon fork)";
    homepage = "https://github.com/pematon/adminer";
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
