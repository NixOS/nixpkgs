{
  buildFHSEnv,
  buildNpmPackage,
  dpkg,
  fetchFromGitHub,
  fetchurl,
  gcc-unwrapped,
  lib,
  lndir,
  nixosTests,
  pkg-config,
  runCommand,
  stdenv,
  vips,
  writeScript,
  x2t,

  extra-fonts ? [ ],
}:

let
  version = "9.2.1";
  server-src = fetchFromGitHub {
    owner = "ONLYOFFICE";
    repo = "server";
    tag = "v9.2.1.1";
    hash = "sha256-McG+PGL+ZmmnInuBhqVqMeX0o36/LbC0C5vQA1TDjO8=";
  };
  common = buildNpmPackage (finalAttrs: {
    name = "onlyoffice-server-Common";
    src = server-src;
    sourceRoot = "${finalAttrs.src.name}/Common";
    npmDepsHash = "sha256-zFGqDtnNFzXCwp6uvK04GDMRG6BATv6ti3Wi8ikLjBU=";
    dontNpmBuild = true;
    postPatch = ''
      # https://github.com/ONLYOFFICE/build_tools/blob/ef8153c053bed41909ceb0762b124f8fe7faa0a7/scripts/build_server.py#L34
      sed -e "s/^const buildVersion = '[0-9.]*'/const buildVersion = '${version}'/" -i sources/commondefines.js
    '';
    postInstall = ''
      ln -s $out/lib/node_modules/common $out/lib/node_modules/Common
    '';
  });
  docservice = buildNpmPackage (finalAttrs: {
    name = "onlyoffice-server-DocService";
    src = server-src;
    sourceRoot = "${finalAttrs.src.name}/DocService";
    nativeBuildInputs = [
      pkg-config
    ];
    buildInputs = [
      vips.dev
    ];
    npmDepsHash = "sha256-4t3wrO+Tt3bTRzmvB+tbVr5D3fXpn7CCU7+dNRc7xEo=";
    npmFlags = [ "--loglevel=verbose" ];
    dontNpmBuild = true;
    postInstall = ''
      # it would be neater if this were a 'ln -s', but this is not possible
      # because common/sources/notificationService.js has a circular dependency
      # back on DocService
      cp -r ${common}/lib/node_modules/common $out/lib/node_modules/Common
      ln -s $out/lib/node_modules/coauthoring $out/lib/node_modules/DocService
    '';
  });
  fileconverter = buildNpmPackage (finalAttrs: {
    name = "onlyoffice-server-FileConverter";
    src = server-src;

    sourceRoot = "${finalAttrs.src.name}/FileConverter";

    npmDepsHash = "sha256-JKZqbpVBNe6dwxsTg8WqlJAlAqOYmqm+LyWgIxpRb8k=";

    dontNpmBuild = true;

    postInstall = ''
      ln -s ${common}/lib/node_modules/common $out/lib/node_modules/Common
      ln -s ${docservice}/lib/node_modules/coauthoring $out/lib/node_modules/DocService
    '';
  });

  # https://github.com/ONLYOFFICE/document-server-package/blob/master/common/documentserver/bin/documentserver-generate-allfonts.sh.m4
  x2t-with-fonts-and-themes = runCommand "x2t-with-fonts-and-themes" { } ''
    mkdir -p $out/web
    mkdir -p $out/converter
    mkdir -p $out/images
    mkdir -p $out/fonts

    echo Generating fonts
    export CUSTOM_FONTS_PATHS=${lib.concatStringsSep ":" extra-fonts}
    ${x2t.components.allfontsgen}/bin/allfontsgen \
      --input=${x2t.components.core-fonts} \
      --allfonts-web=$out/web/AllFonts.js \
      --allfonts=$out/converter/AllFonts.js \
      --images=$out/images \
      --selection=$out/converter/font_selection.bin \
      --output-web=$out/fonts \
      --use-system=true

    mkdir -p $out/bin
    cp ${x2t}/bin/x2t $out/bin
    cat >$out/bin/DoctRenderer.config <<EOF
      <Settings>
        <file>${x2t.components.sdkjs}/common/Native/native.js</file>
        <file>${x2t.components.sdkjs}/common/Native/jquery_native.js</file>
        <allfonts>$out/converter/AllFonts.js</allfonts>
        <file>${x2t.components.web-apps}/vendor/xregexp/xregexp-all-min.js</file>
        <sdkjs>${x2t.components.sdkjs}</sdkjs>
        <dictionaries>${x2t.components.dictionaries}</dictionaries>
      </Settings>
    EOF

    echo Generating presentation themes
    # creates temporary files next to sources...
    mkdir working
    cp ${x2t.components.sdkjs}/slide/themes/src/* working
    ${x2t.components.allthemesgen}/bin/allthemesgen \
      --converter-dir="$out/bin"\
      --src="working"\
      --output="$out/images"
    ${x2t.components.allthemesgen}/bin/allthemesgen \
      --converter-dir="$out/bin"\
      --src="working"\
      --output="$out/images"\
      --postfix="ios"\
      --params="280,224"
    ${x2t.components.allthemesgen}/bin/allthemesgen \
      --converter-dir="$out/bin"\
      --src="working"\
      --output="$out/images"\
      --postfix="android"\
      --params="280,224"
  '';
  # var/www/onlyoffice/documentserver/server/DocService/docservice
  onlyoffice-documentserver = stdenv.mkDerivation {
    pname = "onlyoffice-documentserver";
    version = "9.2.1";

    src = fetchFromGitHub {
      owner = "ONLYOFFICE";
      repo = "document-server-package";
      tag = "v9.2.1.13";
      hash = "sha256-jyXSYkWu63vdeWsRm1Pl/3p3jRjasj0whzN0CytdHks=";
    };

    buildPhase = ''
      runHook preBuild
      # nothing for now
      runHook postBuild
    '';

    installPhase = ''
      mkdir -p $out/etc/onlyoffice/documentserver/log4js
      cp ${server-src}/Common/config/default.json $out/etc/onlyoffice/documentserver
      cp ${server-src}/Common/config/production-linux.json $out/etc/onlyoffice/documentserver
      cp ${server-src}/Common/config/log4js/production.json $out/etc/onlyoffice/documentserver/log4js

      mkdir -p $out/var/www/onlyoffice/documentserver-example
      cp -r common/documentserver-example/welcome $out/var/www/onlyoffice/documentserver-example

      mkdir -p $out/var/www/onlyoffice/documentserver

      # equivalent of usr/bin/documentserver-flush-cache.sh,
      # busts cache also when fonts collection changes
      mkdir $out/var/www/onlyoffice/documentserver/web-apps
      ${lndir}/bin/lndir -silent ${x2t.components.web-apps} $out/var/www/onlyoffice/documentserver/web-apps
      mv $out/var/www/onlyoffice/documentserver/web-apps/apps/api/documents/api.js{,.orig}
      sed -e "s/{{HASH_POSTFIX}}/$(basename $out | cut -d '-' -f 1)/" $out/var/www/onlyoffice/documentserver/web-apps/apps/api/documents/api.js.orig > $out/var/www/onlyoffice/documentserver/web-apps/apps/api/documents/api.js

      ln -s ${x2t-with-fonts-and-themes}/fonts $out/var/www/onlyoffice/documentserver/fonts

      mkdir -p $out/var/www/onlyoffice/documentserver/sdkjs
      ${lndir}/bin/lndir -silent ${x2t.components.sdkjs} $out/var/www/onlyoffice/documentserver/sdkjs
      ln -s ${x2t-with-fonts-and-themes}/web/AllFonts.js $out/var/www/onlyoffice/documentserver/sdkjs/common/AllFonts.js
      ${lndir}/bin/lndir -silent ${x2t-with-fonts-and-themes}/images $out/var/www/onlyoffice/documentserver/sdkjs/common/Images

      # we don't currently support sdkjs plugins in NixOS
      # https://github.com/ONLYOFFICE/build_tools/blob/master/scripts/deploy_server.py#L130
      mkdir -p $out/var/www/onlyoffice/documentserver/sdkjs-plugins
      echo "[]" > $out/var/www/onlyoffice/documentserver/sdkjs-plugins/plugin-list-default.json

      mkdir -p $out/var/www/onlyoffice/documentserver/server/schema
      cp -r ${server-src}/schema/* $out/var/www/onlyoffice/documentserver/server/schema

      ## required for bwrap --bind
      chmod u+w $out/var
      mkdir -p $out/var/lib/onlyoffice
    '';

    # stripping self extracting javascript binaries likely breaks them
    dontStrip = true;

    passthru = {
      inherit
        x2t-with-fonts-and-themes
        common
        docservice
        fileconverter
        ;
      tests = nixosTests.onlyoffice;
      fhs = buildFHSEnv {
        name = "onlyoffice-wrapper";

        targetPkgs = pkgs: [
          gcc-unwrapped.lib
          onlyoffice-documentserver
          fileconverter
        ];

        extraBuildCommands = ''
          mkdir -p $out/var/{lib/onlyoffice,www}
          cp -ar ${onlyoffice-documentserver}/var/www/* $out/var/www/
        '';

        extraBwrapArgs = [
          "--bind var/lib/onlyoffice/ var/lib/onlyoffice/"
        ];
      };
    };

    meta = {
      description = "ONLYOFFICE Document Server is an online office suite comprising viewers and editors";
      longDescription = ''
        ONLYOFFICE Document Server is an online office suite comprising viewers and editors for texts, spreadsheets and presentations,
        fully compatible with Office Open XML formats: .docx, .xlsx, .pptx and enabling collaborative editing in real time.
      '';
      homepage = "https://github.com/ONLYOFFICE/DocumentServer";
      license = lib.licenses.agpl3Plus;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      maintainers = with lib.maintainers; [ raboof ];
    };
  };
in
onlyoffice-documentserver
