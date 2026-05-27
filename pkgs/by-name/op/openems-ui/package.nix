{
  lib,
  buildNpmPackage,
  pkg-config,
  vips,
  openems-edge,
  websocket-port ? 8082,
  ...
}:
buildNpmPackage (finalAttrs: {

  pname = "openems-ui";

  inherit (openems-edge)
    version
    src
    ;

  sourceRoot = "${finalAttrs.src.name}/ui";

  strictDeps = true;

  __structuredAttrs = true;

  npmDepsHash = "sha256-PNAU5MYJTjjUaqYG4Y10YhEQmT79TCpByezItHRb7qc=";

  nativeBuildInputs = [
    pkg-config
    vips
  ];

  buildInputs = [
    vips
  ];

  dontNpmBuild = true;

  postPatch = ''
    # Disable font inlining, which is impure
    substituteInPlace angular.json \
      --replace-fail '"fonts": true' '"fonts": false'
  ''
  # The openems-ui build configurations hardcode the websocket ports.
  # To allow for customisation, we have to replace it in the source.
  # 8082 is the default port of the openems,openems-backend-prod,prod configuration.
  + (lib.optionalString (websocket-port != 8082) ''
    substituteInPlace src/themes/openems/environments/backend-prod.ts \
      --replace-fail ':8082' ':${toString websocket-port}'
  '');

  buildPhase = ''
    runHook preBuild
    mkdir -p $out/share/openems-ui
    node_modules/.bin/ng build \
      --configuration "openems,prod" \
      --output-path $out/share/openems-ui
    runHook postBuild
  '';

  doInstall = false;

  meta = {
    description = "Open energy management system (UI component)";
    license = lib.licenses.agpl3Only;
    homepage = "https://openems.io/";
    changelog = "https://github.com/openems/openems/releases/tag/${finalAttrs.version}";
    maintainers = [ lib.maintainers.mrcjkb ];
    mainProgram = "openems-ui";
    platforms = lib.platforms.all;
  };

})
