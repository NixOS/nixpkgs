{
  buildFHSEnv,
  callPackage,
  fetchFromGitHub,
  gcc-unwrapped,
  lib,
  lndir,
  nix-update,
  nixosTests,
  stdenvNoCC,
  onlyoffice-documentserver,
  writeShellScript,

  extra-fonts ? [ ],
}:

let
  version = "9.3.7-1";

  # TODO: build x2t from Euro-Office/core etc. and/or move
  # x2t-with-fonts-and-themes into its own shared package.
  # See https://github.com/NixOS/nixpkgs/pull/504934#issuecomment-4230304870
  x2t = onlyoffice-documentserver.x2t;

  server-src = fetchFromGitHub {
    owner = "Euro-Office";
    repo = "server";
    tag = "v${version}";
    hash = "sha256-MCF9MlvDLPxBKD3Qqx8zXKYVNQzbX/9kF82d01wggio=";
  };

  # These are required but not included in the submodules for some reason.
  # https://github.com/ONLYOFFICE/server/blob/34adaeeb4cc1e032a5cf188924880a25546dc67c/Makefile#L81-L83
  document-templates-src = fetchFromGitHub {
    owner = "Euro-Office";
    repo = "document-templates";
    tag = "v${version}";
    hash = "sha256-bEWQougTiMxedYasnj7N3bsyA2NwXxQkrco5knHJ7V4=";
  };
  document-formats-src = fetchFromGitHub {
    owner = "Euro-Office";
    repo = "document-formats";
    tag = "v${version}";
    hash = "sha256-8q+raWUoKHjY8yhME/wW6Hhg6jU3IHjGwiByhlm8tj4=";
  };

  common = callPackage ./common.nix { inherit version server-src; };
  docservice = callPackage ./docservice.nix { inherit version server-src common; };
  fileconverter = callPackage ./fileconverter.nix {
    inherit
      version
      server-src
      common
      docservice
      ;
  };
  x2t-with-fonts-and-themes = callPackage ./x2t-with-fonts-and-themes.nix {
    inherit x2t extra-fonts;
  };
in
# var/www/onlyoffice/documentserver/server/DocService/docservice
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "euro-office-documentserver";
  version = version;

  src = fetchFromGitHub {
    owner = "Euro-Office";
    repo = "document-server-package";
    tag = "v${version}";
    hash = "sha256-syrS6xXPw1q6lzyuPEO1TE8d0LIB1y9XEH01fR/6ASQ=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Upstream Makefile wont work on here
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    lndir
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc/onlyoffice/documentserver/log4js
    cp ${server-src}/Common/config/default.json $out/etc/onlyoffice/documentserver
    cp ${server-src}/Common/config/production-linux.json $out/etc/onlyoffice/documentserver
    cp ${server-src}/Common/config/log4js/production.json $out/etc/onlyoffice/documentserver/log4js

    mkdir -p $out/var/www/onlyoffice/documentserver-example
    # FIXME open upstream issue to support following symlinks
    cp -r common/documentserver-example/welcome $out/var/www/onlyoffice/documentserver-example

    mkdir -p $out/var/www/onlyoffice/documentserver
    # equivalent of usr/bin/documentserver-flush-cache.sh,
    # busts cache also when fonts collection changes
    mkdir $out/var/www/onlyoffice/documentserver/web-apps
    ${lib.getExe lndir} -silent ${x2t.components.web-apps} $out/var/www/onlyoffice/documentserver/web-apps
    mv $out/var/www/onlyoffice/documentserver/web-apps/apps/api/documents/api.js{,.orig}
    sed -e "s/{{HASH_POSTFIX}}/$(basename $out | cut -d '-' -f 1)/" $out/var/www/onlyoffice/documentserver/web-apps/apps/api/documents/api.js.orig > $out/var/www/onlyoffice/documentserver/web-apps/apps/api/documents/api.js

    ln -s ${x2t-with-fonts-and-themes}/fonts $out/var/www/onlyoffice/documentserver/fonts

    mkdir -p $out/var/www/onlyoffice/documentserver/sdkjs
    ${lib.getExe lndir} -silent ${x2t.components.sdkjs} $out/var/www/onlyoffice/documentserver/sdkjs
    ln -s ${x2t-with-fonts-and-themes}/web/AllFonts.js $out/var/www/onlyoffice/documentserver/sdkjs/common/AllFonts.js
    ${lib.getExe lndir} -silent ${x2t-with-fonts-and-themes}/images $out/var/www/onlyoffice/documentserver/sdkjs/common/Images

    # we don't currently support sdkjs plugins in NixOS
    # https://github.com/ONLYOFFICE/build_tools/blob/master/scripts/deploy_server.py#L130
    mkdir -p $out/var/www/onlyoffice/documentserver/sdkjs-plugins
    echo "[]" > $out/var/www/onlyoffice/documentserver/sdkjs-plugins/plugin-list-default.json

    mkdir -p $out/var/www/onlyoffice/documentserver/server/schema
    # FIXME open upstream issue to support following symlinks
    cp -r ${server-src}/schema/* $out/var/www/onlyoffice/documentserver/server/schema

    ln -s ${document-templates-src} $out/var/www/onlyoffice/documentserver/document-templates
    ln -s ${document-formats-src} $out/var/www/onlyoffice/documentserver/document-formats

    # required for bwrap --bind
    chmod u+w $out/var

    runHook postInstall
  '';

  # stripping self extracting javascript binaries likely breaks them
  dontStrip = true;

  passthru = {
    inherit
      x2t-with-fonts-and-themes
      common
      docservice
      fileconverter
      server-src
      document-templates-src
      document-formats-src
      ;

    # nix-update only updates the main `src` by default. The auxiliary
    # sources and the npm dependencies live in separate files, so update
    # them explicitly.
    updateScript = writeShellScript "euro-office-documentserver-update.sh" ''
      set -eu

      ${lib.getExe nix-update} "''${UPDATE_NIX_ATTR_PATH:-euro-office-documentserver}" \
        --custom-dep server-src \
        --custom-dep document-templates-src \
        --custom-dep document-formats-src

      ${lib.getExe nix-update} "''${UPDATE_NIX_ATTR_PATH:-euro-office-documentserver}" \
        --version skip \
        --subpackage common \
        --subpackage docservice \
        --subpackage fileconverter
    '';

    tests.onlyoffice = nixosTests.onlyoffice.passthru.override {
      package = finalAttrs.finalPackage;
    };
    fhs = buildFHSEnv {
      name = "euro-office-wrapper";

      targetPkgs = pkgs: [
        gcc-unwrapped.lib
        finalAttrs.finalPackage
        fileconverter
      ];

      extraBuildCommands = ''
        # Both mount points must exist, services.onlyoffice.stateDir selects
        # which one is actually bound at runtime.
        mkdir -p $out/var/lib/onlyoffice $out/var/lib/euro-office $out/var/www
        cp -ar ${finalAttrs.finalPackage}/var/www/* $out/var/www/
      '';

      extraBwrapArgs = [
        # bind-try: services.onlyoffice.stateDir selects which of these exists.
        "--bind-try var/lib/onlyoffice/ var/lib/onlyoffice/"
        # Euro-Office upstream defaults reference var/lib/euro-office.
        "--bind-try var/lib/euro-office/ var/lib/euro-office/"
      ];
    };
  };

  meta = {
    description = "Online office suite comprising viewers and editors";
    longDescription = ''
      Euro-Office Document Server is an online office suite comprising viewers and editors for texts, spreadsheets and presentations,
      fully compatible with Office Open XML formats: .docx, .xlsx, .pptx and enabling collaborative editing in real time.
    '';
    homepage = "https://github.com/Euro-Office/DocumentServer";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.onny ];
  };
})
