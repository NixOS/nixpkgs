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
  npmDepsHash ? null,
  vendorHash ? null,
  npmPostPatch ? "",
  npmNativeBuildInputs ? [ ],
  npmBuildInputs ? [ ],
  extraFiles ? [ ],
}:
let
  npmAssets =
    if npmDepsHash != null then
      buildNpmPackage (
        {
          inherit
            version
            src
            ;
          pname = "${pname}-npm";

          postPatch = ''
            rm -f Makefile
            ${npmPostPatch}
          '';

          makeCacheWritable = true;
          PUPPETEER_SKIP_DOWNLOAD = 1;
          CYPRESS_INSTALL_BINARY = 0;
          nativeBuildInputs = npmNativeBuildInputs;
          buildInputs = npmBuildInputs;
          npmFlags = [ "--legacy-peer-deps" ];

          installPhase = ''
            mkdir $out
            for dir in css js; do
              if [ -d $dir ]; then
                cp -r $dir $out
              fi
            done
          '';
        }
        // lib.optionalAttrs (npmDepsHash != null) { inherit npmDepsHash; }
      )
    else
      # An app might ship some Javascript/CSS without npm, but then these are the source files and not compiled ones.
      stdenvNoCC.mkDerivation {
        inherit version src;
        pname = "${pname}-direct";

        postPatch = ''
          rm -f Makefile
        '';

        installPhase = ''
          mkdir $out
          for dir in css js; do
            if [ -d $dir ]; then
              cp -r $dir $out
            fi
          done
        '';
      };
  composerAssets =
    if vendorHash != null then
      php.mkComposerVendor {
        inherit
          version
          src
          vendorHash
          ;
        pname = "${pname}-composer";

        postPatch = ''
          rm -f Makefile
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
    else
      null;
in
stdenvNoCC.mkDerivation {
  inherit pname version src;

  postPatch = ''
    rm -rf Makefile js l10n/.gitkeep
  '';

  buildPhase = ''
    for dir in js css; do
      if [ -d ${npmAssets}/$dir ]; then
        cp -r ${npmAssets}/$dir .
        chmod a+rw -R $dir
      fi
    done

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
