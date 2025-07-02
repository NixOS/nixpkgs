{
  lib,
  gitMinimal,
  python3,
  fetchFromGitHub,
  nix-update-script,
  cacert,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  stdenv,
}:
let
  version = "4.10.0";
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      craft-application = super.craft-application.overridePythonAttrs (old: {
        inherit version;
        src = fetchFromGitHub {
          owner = "canonical";
          repo = "craft-application";
          tag = version;
          hash = "sha256-9M49/XQuWwKuQqseleTeZYcrwd/S16lNCljvlVsoXbs=";
        };

        postPatch = ''
          substituteInPlace pyproject.toml --replace-fail "setuptools==75.8.0" "setuptools"
          substituteInPlace craft_application/git/_git_repo.py --replace-fail "/snap/core22/current/etc/ssl/certs" "${cacert}/etc/ssl/certs"
        '';

        disabledTestPaths = [
          # These tests assert outputs of commands that assume Ubuntu-related output.
          "tests/unit/services/test_lifecycle.py"
        ];

        disabledTests =
          old.disabledTests
          ++ lib.optionals stdenv.hostPlatform.isAarch64 [
            "test_process_grammar_full"
          ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "charmcraft";
  version = "3.5.2";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    tag = version;
    hash = "sha256-WpiLi8raY1f6+Jjlamp+eDh429gjSwSufNfoPOcGIgU=";
  };

  postPatch = ''
    substituteInPlace charmcraft/__init__.py --replace-fail "dev" "${version}"
  '';

  dependencies = with python.pkgs; [
    craft-application
    craft-cli
    craft-parts
    craft-platforms
    craft-providers
    craft-store
    distro
    docker
    humanize
    jinja2
    jsonschema
    pip
    pydantic
    python-dateutil
    pyyaml
    requests
    requests-toolbelt
    requests-unixsocket
    snap-helpers
    tabulate
    urllib3
  ];

  build-system = with python.pkgs; [ setuptools-scm ];

  pythonRelaxDeps = [
    "urllib3"
    "craft-application"
    "pip"
    "pydantic"
  ];

  nativeCheckInputs =
    with python.pkgs;
    [
      freezegun
      hypothesis
      pyfakefs
      pytest-check
      pytest-mock
      pytest-subprocess
      pytestCheckHook
      responses
      setuptools
    ]
    ++ [
      cacert
      gitMinimal
      versionCheckHook
      writableTmpDirAsHomeHook
    ];

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    # Relies upon the `charm` tool being installed
    "test_validate_missing_charm"
    "test_read_charm_from_yaml_file_self_contained_success[full-bases.yaml]"
    "test_read_charm_from_yaml_file_self_contained_success[full-platforms.yaml]"
  ];

  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "SSL_CERT_FILE" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "charmcraft";
    description = "Build and publish Charmed Operators for deployment with Juju";
    homepage = "https://github.com/canonical/charmcraft";
    changelog = "https://github.com/canonical/charmcraft/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
