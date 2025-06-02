{
  lib,
  git,
  python3,
  fetchFromGitHub,
  nix-update-script,
  testers,
  charmcraft,
  cacert,
}:
let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      craft-application = super.craft-application.overridePythonAttrs (old: rec {
        version = "4.10.0";
        src = fetchFromGitHub {
          owner = "canonical";
          repo = "craft-application";
          tag = version;
          hash = "sha256-9M49/XQuWwKuQqseleTeZYcrwd/S16lNCljvlVsoXbs=";
        };

        patches = [ ];

        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace-fail "setuptools==75.8.0" "setuptools"

          substituteInPlace craft_application/git/_git_repo.py \
            --replace-fail "/snap/core22/current/etc/ssl/certs" "${cacert}/etc/ssl/certs"
        '';

        preCheck = ''
          export HOME=$(mktemp -d)

          # Tests require access to /etc/os-release, which isn't accessible in
          # the test environment, so create a fake file, and modify the code
          # to look for it.
          echo 'ID=nixos' > $HOME/os-release
          echo 'NAME=NixOS' >> $HOME/os-release
          echo 'VERSION_ID="24.05"' >> $HOME/os-release

          substituteInPlace craft_application/util/platforms.py \
            --replace-fail "os_utils.OsRelease()" "os_utils.OsRelease(os_release_file='$HOME/os-release')"
        '';
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "charmcraft";
  version = "3.4.6";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "charmcraft";
    tag = version;
    hash = "sha256-i7XhsVmeO3fzAWCQ1v9J/dv4oSdN00svauIColQcj9A=";
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
      git
    ];

  preCheck = ''
    mkdir -p check-phase
    export HOME="$(pwd)/check-phase"
  '';

  pytestFlagsArray = [ "tests/unit" ];

  disabledTests = [
    # Relies upon the `charm` tool being installed
    "test_validate_missing_charm"
    "test_read_charm_from_yaml_file_self_contained_success[full-bases.yaml]"
    "test_read_charm_from_yaml_file_self_contained_success[full-platforms.yaml]"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = charmcraft;
      command = "env SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt HOME=$(mktemp -d) charmcraft --version";
      version = "charmcraft ${version}";
    };
  };

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
