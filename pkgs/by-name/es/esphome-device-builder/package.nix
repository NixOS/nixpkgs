{
  lib,
  python3Packages,
  fetchFromGitHub,
  nodejs,
  fetchNpmDeps,
  npmHooks,
  git,
  versionCheckHook,
  nix-update-script,
  platformio,
  esphome,
}:

let
  python = python3Packages.python.override {
    self = python;
    packageOverrides = self: super: {
      esphome-device-builder-frontend = super.buildPythonPackage (finalAttrs: {
        pname = "esphome-device-builder-frontend";
        version = "0.1.194";
        pyproject = true;

        __structuredAttrs = true;
        strictDeps = true;

        src = fetchFromGitHub {
          owner = "esphome";
          repo = "device-builder-frontend";
          tag = finalAttrs.version;
          hash = "sha256-RrmaAmSoyhK5YcY48A+Cpjz3kxVN5h2AEPvjkzuGsoY=";
        };

        npmDeps = fetchNpmDeps {
          inherit (finalAttrs) src;
          hash = "sha256-Qr2ZUmHr0YEUQOebYQxhCRKXZmGO2t/ur2J7QMDK+JQ=";
        };

        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
        '';

        nativeBuildInputs = [
          nodejs
          npmHooks.npmConfigHook
        ];

        build-system = with super.python.pkgs; [
          setuptools
        ];

        preBuild = ''
          npm run build
        '';

        pythonImportsCheck = [
          "esphome_device_builder_frontend"
        ];
      });
    };
  };
in

python.pkgs.buildPythonApplication (finalAttrs: {
  pname = "esphome-device-builder";
  version = "1.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esphome";
    repo = "device-builder";
    tag = finalAttrs.version;
    hash = "sha256-3nBpi5tUxOBgz0w4jJ8bYf5R2n7IUBy/Z319Pnt+beM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  __structuredAttrs = true;
  strictDeps = true;

  build-system = with python.pkgs; [
    setuptools
  ];

  dependencies = with python.pkgs; [
    python.pkgs.esphome
    esphome-device-builder-frontend

    aiohttp
    aiohttp-asyncmdnsresolver
    colorlog
    cryptography
    fnv-hash-fast
    mashumaro
    orjson
    pyyaml
    ruamel-yaml
    voluptuous
  ];

  nativeCheckInputs = with python.pkgs; [
    versionCheckHook
    pytestCheckHook
    pytest-aiohttp
    pytest-codspeed
    pytest-cov-stub
    pytest-timeout
    pytest-xdist
    blockbuster
  ];

  # Needed for tests
  __darwinAllowLocalNetworking = true;

  pytestFlags = [
    "--timeout=30"
  ];

  preCheck = ''
    export PATH=$PATH:${
      lib.makeBinPath [
        esphome
        platformio
        git
      ]
    }
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      esphome
      platformio
      git
    ])

    # The dashboard requires esphome to be importable
    # dependencies are added to show better error messages
    "--prefix"
    "PYTHONPATH"
    ":"
    "$out/${python.sitePackages}:${python.pkgs.makePythonPath finalAttrs.passthru.dependencies}"
  ];

  disabledTestPaths = [
    # consider disabling these tests if test phase is taking excessively long
    # "tests/e2e/slow"

    # presumably fails due to required network access to download LibreTiny
    "tests/e2e/slow/boards/test_create_all_boards.py"
  ];

  disabledTests = [
    # tests that try to access GitHub
    "test_esp_idf_compile_download_round_trip"
    "test_libretiny_bk7231n_compile_download_round_trip"

    # timeout
    "test_get_component_bodies_returns_full_batch_larger_than_cache"
  ];

  passthru = {
    frontend = python.pkgs.esphome-device-builder-frontend;

    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "frontend"
      ];
    };
  };

  meta = {
    changelog = "https://github.com/esphome/device-builder/releases/tag/${finalAttrs.src.tag}";
    description = "ESPHome Device Builder Dashboard ";
    homepage = "https://esphome.io/";
    license = with lib.licenses; [
      asl20
    ];
    maintainers = with lib.maintainers; [
      tmarkus
    ];
    mainProgram = "esphome-device-builder";
  };
})
