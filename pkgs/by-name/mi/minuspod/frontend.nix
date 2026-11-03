{
  lib,
  buildNpmPackage,
  nodejs_26,
  src,
  version,
}:

buildNpmPackage {
  pname = "minuspod-frontend";
  inherit src version;

  sourceRoot = "source/frontend";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-MR9ehQ5sVWip/G4tELxl4ybt4qA+YhfbVKTT5ImU3tc=";

  npmBuildScript = "build";

  postPatch = ''
    substituteInPlace vite.config.ts \
      --replace-fail "'../static/ui'" "'dist'"
  '';

  env.CYPRESS_INSTALL_BINARY = "0";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/minuspod
    cp -r dist $out/share/minuspod/ui

    mkdir -p $out/share/minuspod/ui/swagger
    cp node_modules/swagger-ui-dist/swagger-ui.css \
       node_modules/swagger-ui-dist/swagger-ui-bundle.js \
       node_modules/swagger-ui-dist/swagger-ui-standalone-preset.js \
       $out/share/minuspod/ui/swagger/

    runHook postInstall
  '';

  meta = {
    description = "MinusPod frontend";
    homepage = "https://github.com/ttlequals0/MinusPod";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
