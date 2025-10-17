{
  lib,
  pkgs,
  stdenvNoCC,
  fetchFromGitHub,
  php,
  nix-update-script,
  theme ? null,
  plugins ? [ ],
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  version = "4.8.4";
  pname = "adminerevo";

  src = fetchFromGitHub {
    owner = "adminerevo";
    repo = "adminerevo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cyKSwzoVbS/0Fiv02kFIF4MTOqzpKSEFwwUwS4yqL6Q=";
    fetchSubmodules = true;
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
    cp adminer-${finalAttrs.version}.php $out/adminer.php
    cp ${./index.php} $out/index.php

    ${lib.optionalString (theme != null) ''
      cp designs/${theme}/adminer.css $out/adminer.css
    ''}

    # Copy base plugin
    mkdir -p $out/plugins
    cp plugins/plugin.php $out/plugins/plugin.php

    ${lib.optionalString (plugins != [ ]) ''
      cp plugins/*.php $out/plugins/
      cp ${pkgs.writeText "$out/plugins.json" ''
        ${toString (builtins.toJSON plugins)}
      ''} $out/plugins.json
    ''}

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Database management in a single PHP file";
    homepage = "https://docs.adminerevo.org";
    license = with licenses; [
      asl20
      gpl2Only
    ];
    maintainers = [ ];
    platforms = platforms.all;
  };
})
