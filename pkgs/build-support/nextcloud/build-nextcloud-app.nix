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
          npmFlags = [ "--legacy-peer-deps" ];

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
      php.mkComposerVendor {
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
      }
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

  buildPhase = ''
    ${lib.optionalString (npmAssets != null) ''
      for dir in js css; do
        if [ -d ${npmAssets}/$dir ]; then
          cp -r ${npmAssets}/$dir .
          chmod a+rw -R $dir
        fi
      done
    ''}

    ${lib.optionalString (composerAssets != null) ''
      if [ -d ${composerAssets}/vendor ]; then
        cp -r ${composerAssets}/vendor .
        chmod a+rw -R vendor
      fi
    ''}

    if [ -f .nextcloudignore ]; then
      cat .nextcloudignore | xargs -I {} rm -rf "$(pwd)/{}"
    fi
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
          "js"
          "css"
          "vendor"
        ]
    )}
    ${lib.concatStringsSep "\n" (map (entry: "cp -r ${entry} $out") extraFiles)}
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
