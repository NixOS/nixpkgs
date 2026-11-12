{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  fetchpatch,
  callPackage,
  runCommand,
  python3,
  encryptionSupport ? true,
}:

let
  python = python3;

  frontend = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "maubot-frontend";
    inherit (maubot) version src;

    sourceRoot = "${finalAttrs.src.name}/maubot/management/frontend";

    offlineCache = fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/maubot/management/frontend/yarn.lock";
      hash = "sha256-VBPZbtqF9u63yRgk0PObhUMvV8s7UXSs6nr87cPeLz4=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      nodejs
    ];

    installPhase = ''
      runHook preInstall

      mv build $out

      runHook postInstall
    '';
  });

  maubot = python.pkgs.buildPythonApplication (finalAttrs: {
    pname = "maubot";
    version = "0.6.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "maubot";
      repo = "maubot";
      tag = "v${finalAttrs.version}";
      hash = "sha256-kLToWYqnIw+lkmOrWAHOetoFF2usumg4Vf8F2tIlj+s=";
    };

    patches = [
      # add entry point - https://github.com/maubot/maubot/pull/146
      (fetchpatch {
        url = "https://github.com/maubot/maubot/commit/ef6e23eccb530187dd3447b6aac2047d4a32fb83.patch";
        hash = "sha256-d5fu47F93aXZmk6MiSsxTE8pHjMKNL0FUdU+ynUqY2o=";
      })
    ];

    build-system = with python.pkgs; [
      setuptools
    ];

    dependencies =
      with python.pkgs;
      [
        # requirements.txt
        (mautrix.override { withOlm = encryptionSupport; })
        aiohttp
        yarl
        asyncpg
        aiosqlite
        commonmark
        ruamel-yaml
        attrs
        bcrypt
        packaging
        click
        colorama
        questionary
        jinja2
      ]
      # optional-requirements.txt
      ++ lib.optionals encryptionSupport [
        python-olm
        pycryptodome
        unpaddedbase64
      ];

    # used for plugin tests
    propagatedNativeBuildInputs = with python.pkgs; [
      pytest
      pytest-asyncio
    ];

    postInstall = ''
      mkdir -p $out/${python.sitePackages}/maubot/management/frontend
      ln -s ${frontend} $out/${python.sitePackages}/maubot/management/frontend/build
      rm $out/example-config.yaml
    '';

    pythonRelaxDeps = [
      "bcrypt"
      "ruamel.yaml"
    ];

    pythonImportsCheck = [
      "maubot"
    ];

    passthru =
      let
        wrapper = callPackage ./wrapper.nix {
          unwrapped = maubot;
          python3 = python;
        };
      in
      {
        tests = {
          simple = runCommand "${finalAttrs.pname}-tests" { } ''
            ${maubot}/bin/mbc --help > $out
          '';
        };

        inherit python frontend;

        plugins = callPackage ./plugins {
          maubot = maubot;
          python3 = python;
        };

        withPythonPackages = pythonPackages: wrapper { inherit pythonPackages; };

        # This adds the plugins to lib/maubot-plugins
        withPlugins = plugins: wrapper { inherit plugins; };

        # This changes example-config.yaml in module directory
        withBaseConfig = baseConfig: wrapper { inherit baseConfig; };
      };

    meta = {
      description = "Plugin-based Matrix bot system written in Python";
      homepage = "https://maubot.xyz/";
      changelog = "https://github.com/maubot/maubot/blob/v${finalAttrs.version}/CHANGELOG.md";
      license = lib.licenses.agpl3Plus;
      # Presumably, people running "nix run nixpkgs#maubot" will want to run the tool
      # for interacting with Maubot rather than Maubot itself, which should be used as
      # a NixOS module.
      mainProgram = "mbc";
      maintainers = with lib.maintainers; [ chayleaf ];
    };
  });

in
maubot
