{
  buildFHSEnv,
  buildNpmPackage,
  corefonts,
  dpkg,
  dejavu_fonts,
  fetchFromGitHub,
  fetchurl,
  gcc-unwrapped,
  lib,
  liberation_ttf_v1,
  lndir,
  nixosTests,
  pkg-config,
  stdenv,
  vips,
  writeScript,
  x2t,
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
      ln -s ${x2t.components.web-apps} $out/var/www/onlyoffice/documentserver/web-apps
      # copying instead of linking for now because we want to inject
      # AllFonts.js in here:
      cp -r ${x2t.components.sdkjs} $out/var/www/onlyoffice/documentserver/sdkjs

      # we don't currently support sdkjs plugins in NixOS
      # https://github.com/ONLYOFFICE/build_tools/blob/master/scripts/deploy_server.py#L130
      mkdir -p $out/var/www/onlyoffice/documentserver/sdkjs-plugins
      echo "[]" > $out/var/www/onlyoffice/documentserver/sdkjs-plugins/plugin-list-default.json

      mkdir -p $out/var/www/onlyoffice/documentserver/server/schema
      cp -r ${server-src}/schema/* $out/var/www/onlyoffice/documentserver/server/schema
      mkdir -p $out/var/www/onlyoffice/documentserver/server/FileConverter/bin

      ## required for bwrap --bind
      chmod u+w $out/var
      mkdir -p $out/var/lib/onlyoffice
      chmod u+w $out/var/www/onlyoffice/documentserver
      mkdir $out/var/www/onlyoffice/documentserver/fonts
    '';

    # stripping self extracting javascript binaries likely breaks them
    dontStrip = true;

    passthru = {
      inherit fileconverter common docservice;
      tests = nixosTests.onlyoffice;
      fhs = buildFHSEnv {
        name = "onlyoffice-wrapper";

        targetPkgs = pkgs: [
          gcc-unwrapped.lib
          onlyoffice-documentserver

          # fonts
          corefonts
          dejavu_fonts
          liberation_ttf_v1
          fileconverter
        ];

        extraBuildCommands = ''
          mkdir -p $out/var/{lib/onlyoffice,www}
          cp -ar ${onlyoffice-documentserver}/var/www/* $out/var/www/
        '';

        extraBwrapArgs = [
          "--bind var/lib/onlyoffice/ var/lib/onlyoffice/"
          "--bind var/lib/onlyoffice/documentserver/sdkjs/common/ var/www/onlyoffice/documentserver/sdkjs/common/"
          "--bind var/lib/onlyoffice/documentserver/sdkjs/slide/themes/ var/www/onlyoffice/documentserver/sdkjs/slide/themes/"
          "--bind var/lib/onlyoffice/documentserver/fonts/ var/www/onlyoffice/documentserver/fonts/"
          "--bind var/lib/onlyoffice/documentserver/server/FileConverter/bin/ var/www/onlyoffice/documentserver/server/FileConverter/bin/"
        ];

        runScript = writeScript "onlyoffice-documentserver-run-script" ''
          export NODE_CONFIG_DIR=$2
          export NODE_DISABLE_COLORS=1
          export NODE_ENV=production-linux

          if [[ $1 == *"docservice" ]]; then
            mkdir -p var/www/onlyoffice/documentserver/sdkjs/slide/themes/
            # symlinking themes/src breaks discovery in allfontsgen
            rm -rf var/www/onlyoffice/documentserver/sdkjs/slide/themes/src
            cp -r ${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/sdkjs/slide/themes/src var/www/onlyoffice/documentserver/sdkjs/slide/themes/
            chmod -R u+w var/www/onlyoffice/documentserver/sdkjs/slide/themes/

            # onlyoffice places generated files in those directores
            rm -rf var/www/onlyoffice/documentserver/sdkjs/common/*
            ${lndir}/bin/lndir -silent ${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/sdkjs/common/ var/www/onlyoffice/documentserver/sdkjs/common/
            rm -rf var/www/onlyoffice/documentserver/server/FileConverter/bin/*
            ${lndir}/bin/lndir -silent ${onlyoffice-documentserver}/var/www/onlyoffice/documentserver/server/FileConverter/bin/ var/www/onlyoffice/documentserver/server/FileConverter/bin/

            # https://github.com/ONLYOFFICE/document-server-package/blob/master/common/documentserver/bin/documentserver-generate-allfonts.sh.m4
            # TODO --use-system doesn't actually appear to make a difference?
            echo -n Generating AllFonts.js, please wait...
            "${x2t.components.allfontsgen}/bin/allfontsgen"\
              --input="${x2t.components.core-fonts}"\
              --allfonts-web="var/www/onlyoffice/documentserver/sdkjs/common/AllFonts.js"\
              --allfonts="var/www/onlyoffice/documentserver/server/FileConverter/bin/AllFonts.js"\
              --images="var/www/onlyoffice/documentserver/sdkjs/common/Images"\
              --selection="var/www/onlyoffice/documentserver/server/FileConverter/bin/font_selection.bin"\
              --output-web="var/www/onlyoffice/documentserver/fonts"\
              --use-system="true"
            echo Done

            # TODO x2t brings its on DoctRenderer.config, so it wouldn't pick up the new fonts:
            echo -n Generating presentation themes, please wait...
            "${x2t.components.allthemesgen}/bin/allthemesgen"\
              --converter-dir="${x2t}/bin"\
              --src="var/www/onlyoffice/documentserver/sdkjs/slide/themes"\
              --output="var/www/onlyoffice/documentserver/sdkjs/common/Images"

            "${x2t.components.allthemesgen}/bin/allthemesgen"\
              --converter-dir="${x2t}/bin"\
              --src="var/www/onlyoffice/documentserver/sdkjs/slide/themes"\
              --output="var/www/onlyoffice/documentserver/sdkjs/common/Images"\
              --postfix="ios"\
              --params="280,224"

            "${x2t.components.allthemesgen}/bin/allthemesgen"\
              --converter-dir="${x2t}/bin"\
              --src="var/www/onlyoffice/documentserver/sdkjs/slide/themes"\
              --output="var/www/onlyoffice/documentserver/sdkjs/common/Images"\
              --postfix="android"\
              --params="280,224"
            echo Done
          fi

          exec $1
        '';
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
