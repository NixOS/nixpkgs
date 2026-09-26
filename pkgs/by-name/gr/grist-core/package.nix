{
  lib,
  stdenv,
  callPackage,

  fetchFromGitHub,
  fetchYarnDeps,
  writeScriptBin,

  python3,
  yarn,
  nodejs,
  node-gyp-build,
  node-gyp,
  node-pre-gyp,
  fixup-yarn-lock,

  yarnConfigHook,

  sandboxEnv ? [ ],
  extraPythonPackages ? p: [ ],

  nixosTests,

  enterpriseEdition ? false,

  nix-update-script,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    fetchGristEnterprise = callPackage ./fetch-grist-enterprise.nix { };

    enterprise = fetchGristEnterprise {
      gristSrc = finalAttrs.src;
      inherit (finalAttrs) version;
      hash = "sha256-7lqt+L/Qmx/3kl2zJnRsbmCSmu+iAyzpNnqI/yJD9Q8=";
      offlineCacheHash = "sha256-oMLNZZolY9Wg4DwJyYPDL6K28aEyWcXS9ivnzCuYcS0=";
    };

    pythonEnv = python3.withPackages (
      p:
      extraPythonPackages p
      ++ [
        p.astroid
        p.asttokens
        p.chardet
        p.et-xmlfile
        p.executing
        p.friendly-traceback
        p.iso8601
        p.lazy-object-proxy
        p.openpyxl
        p.phonenumbers
        p.pure-eval
        p.python-dateutil
        p.roman
        p.six
        p.sortedcontainers
        p.stack-data
        p.typing-extensions
        p.unittest-xml-reporting
        p.wrapt
      ]
    );
  in
  {
    pname = "grist-core";
    version = "1.7.19";
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "gristlabs";
      repo = "grist-core";
      tag = "v${finalAttrs.version}";
      hash = "sha256-IKnSluSQnPHO+qAwWF7KR/ukIDHVVulmJqIqaMI88Lg=";
    };

    offlineCache = fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/yarn.lock";
      hash = "sha256-E8LDY7GF9d7+iXxr4BLYRUkwQxcpVihMU6HrXJ80pic=";
    };

    env = {
      # We have our own way to fetch enterprise code because of nix
      GRIST_SKIP_EXT_AUTOSETUP = "1";

      sandboxPath = lib.makeSearchPath "bin" ([ pythonEnv ] ++ sandboxEnv);
      sandboxLibPath = lib.makeLibraryPath ([ pythonEnv ] ++ sandboxEnv);
    };

    strictDeps = true;

    patches = [
      # Currently, gVisor sandboxing assumes the system is following the FHS.
      # We thus adapt the sandboxing for nixos by removing all useless mounts
      # and adding a readonly /nix/store. In particular this implies that all
      # grist users will be able to browse the nix-store.
      #
      # See https://github.com/gristlabs/grist-core/issues/2022 for more details
      ./0001-nixos.patch
    ];

    nativeBuildInputs = [
      yarn
      nodejs
      fixup-yarn-lock
      node-gyp-build
      node-gyp
      node-pre-gyp

      yarnConfigHook

      # napi-postinstall is only used for linting dependencies and/or useless checks
      (writeScriptBin "napi-postinstall" ''
        #!/bin/sh
        # noop
        echo "$@"
      '')

      pythonEnv
    ];

    buildInputs = [ pythonEnv ];

    yarnInstallFlags = [
      "--frozen-lockfile"
      "--force"
      "--ignore-engines"
      "--ignore-platform"
      # "--ignore-scripts"
      "--no-progress"
      "--non-interactive"
      "--offline"
    ];

    postPatch = ''
      rm .yarnrc
    '';

    preConfigure = ''
      export HOME=$(mktemp -d)
      export npm_config_nodedir=${nodejs}

      # This one is needed during install process:
      patchShebangs buildtools/install_edition.sh
    '';

    preBuild = ''
      patchShebangs buildtools
    ''
    + lib.optionalString enterpriseEdition ''

      echo "Copying ext"
      cp -r --preserve=timestamps --reflink=auto -- "${enterprise.src}/ext" ./ext
      chmod -R u+w -- "./ext"

      pushd ext

      yarn config --offline set yarn-offline-mirror ${enterprise.offlineCache}
      fixup-yarn-lock yarn.lock

      yarn install $yarnInstallFlags \
        --production=false

      patchShebangs node_modules

      popd

      ./buildtools/dedupe-ext-types.sh
    '';

    buildPhase = ''
      runHook preBuild

      yarn --offline run build:prod

      runHook postBuild
    '';

    postBuild = ''
      rm -r ./node_modules
      yarn install $yarnInstallFlags \
        --production=true
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/grist-core"

      cp -r {_build,node_modules,sandbox,static,bower_components} "$out/grist-core"
      ${lib.optionalString enterpriseEdition ''
        mkdir -p "$out/grist-core/ext"
        cp -r ext/assets "$out/grist-core/ext/"
        cp -r ext/node_modules "$out/grist-core/ext/"
      ''}

      runHook postInstall
    '';

    postInstall = ''
      unlink $out/grist-core/static/mocha.js
      unlink $out/grist-core/static/sinon.js
      unlink $out/grist-core/static/mocha.css

      unlink $out/grist-core/node_modules/msgpackr/node_modules/.bin/download-msgpackr-prebuilds
      unlink $out/grist-core/node_modules/.bin/download-msgpackr-prebuilds

      unlink $out/grist-core/bower_components/bootstrap

      substituteAllInPlace $out/grist-core/sandbox/gvisor/run.py
    '';

    passthru = {
      inherit pythonEnv;
      enterpriseSrc = enterprise.src;
      enterpriseOfflineCache = enterprise.offlineCache;
      tests.grist-core = nixosTests.grist;

      updateScript = nix-update-script {
        extraArgs = [
          "--custom-dep"
          "enterpriseSrc"
          "--custom-dep"
          "enterpriseOfflineCache"
        ];
      };
    };

    meta = {
      maintainers = with lib.maintainers; [
        sinavir
      ];
      description = ''
        Relational spreadsheet tool that sits between databases and
        spreadsheets.
      '';
      homepage = "https://github.com/gristlabs/grist-core";
      license = if enterpriseEdition then lib.unfree else lib.licenses.asl20;
      platforms = lib.platforms.linux;
    };
  }
)
