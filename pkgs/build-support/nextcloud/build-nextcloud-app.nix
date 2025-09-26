{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  php,
}:
{
  pname,
  version,
  src,
  license,
  changelog,
  description,
  homepage,
  npmDeps ? null,
  npmDepsHash ? null,
  vendorHash ? null,
  npmPostPatch ? "",
  npmNativeBuildInputs ? [ ],
  npmBuildInputs ? [ ],
  npmPreBuild ? "",
  npmFlags ? [ ],
  npmRebuildFlags ? [ ],
  extraFiles ? [ ],
}:
let
  npmAssets =
    if npmDeps != null || npmDepsHash != null then
      buildNpmPackage (
        {
          inherit
            version
            src
            npmFlags
            npmRebuildFlags
            ;
          pname = "${pname}-npm";

          patchPhase = ''
            runHook prePatch

            rm -f Makefile

            runHook postPatch
          '';

          postPatch = npmPostPatch;

          makeCacheWritable = true;
          PUPPETEER_SKIP_DOWNLOAD = 1;
          CYPRESS_INSTALL_BINARY = 0;
          nativeBuildInputs = npmNativeBuildInputs;
          buildInputs = npmBuildInputs;
          preBuild = npmPreBuild;

          installPhase = ''
            mkdir $out
            if [ -d js ]; then
              cp -r js $out
            fi
            if [ -d css ]; then
              cp -r css $out
            fi
          '';
        }
        // lib.optionalAttrs (npmDeps != null) { inherit npmDeps; }
        // lib.optionalAttrs (npmDepsHash != null) { inherit npmDepsHash; }
      )
    else if builtins.pathExists "${src}/package.json" then
      throw "package.json exists, but npmDepsHash was not provided"
    else if builtins.pathExists "${src}/js" || builtins.pathExists "${src}/css" then
      # An app might ship some Javascript/CSS without npm, but then these are the source files and not compiled ones.
      stdenvNoCC.mkDerivation {
        inherit version src;
        pname = "${pname}-direct";

        patchPhase = ''
          rm -f Makefile
        '';

        installPhase = ''
          mkdir $out
          if [ -d js ]; then
            cp -r js $out
          fi
          if [ -d css ]; then
            cp -r css $out
          fi
        '';
      }
    else
      null;
  composerAssets =
    if vendorHash != null then
      php.buildComposerProject2 (finalAttrs: {
        inherit
          version
          src
          vendorHash
          ;
        pname = "${pname}-composer";

        patchPhase = ''
          runHook prePatch

          rm -f Makefile

          runHook postPatch
        '';

        composerNoDev = true;
        composerNoPlugins = true;
        composerNoScripts = true;
        composerStrictValidation = false;
        strictDeps = true;

        postBuild = ''
          rm -rf vendor/bin
        '';

        installPhase = ''
          mkdir $out
          declare -g composerVendor
          cp -r "''${composerVendor}/." $out
        '';
      })
    else if builtins.pathExists "${src}/composer.json" then
      throw "composer.json exists, but vendorHash was not provided"
    else
      null;
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  postPatch = ''
    rm -rf Makefile js l10n/.gitkeep
  '';

  installPhase = ''
    mkdir $out

    cp -r {appinfo,lib} $out
    cp openapi*.json $out || true
    ${lib.concatStringsSep "\n" (
      map
        (entry: ''
          if [ -e ${entry} ]; then
            cp -r ${entry} $out
          fi
        '')
        [
          "3rdparty"
          "ajax"
          "img"
          "l10n"
          "templates"
        ]
    )}
    ${lib.concatStringsSep "\n" (map (entry: "cp -r ${entry} $out") extraFiles)}

    ${lib.optionalString (npmAssets != null) ''
      for dir in js css; do
        if [ -d ${npmAssets}/$dir ]; then
          ln -s ${npmAssets}/$dir $out/$dir
        fi
      done
    ''}
    ${lib.optionalString (composerAssets != null) ''
      if [ -d ${composerAssets}/vendor ]; then
        ln -s ${composerAssets}/vendor $out/vendor
      fi
    ''}
  '';

  meta = {
    inherit
      license
      changelog
      description
      homepage
      ;
    teams = [ lib.teams.nextcloud ];
    platforms = lib.platforms.linux;
  };
}
