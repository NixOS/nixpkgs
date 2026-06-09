{
  lib,
  fetchFromGitHub,
  git,
  python3,
}:

let
  py = python3.override {
    packageOverrides = self: super: {

      # Doesn't support latest marshmallow
      marshmallow = super.marshmallow.overridePythonAttrs (oldAttrs: rec {
        version = "3.26.2";
        src = fetchFromGitHub {
          owner = "marshmallow-code";
          repo = "marshmallow";
          tag = version;
          hash = "sha256-ioe+aZHOW8r3wF3UknbTjAP0dEggd/NL9PTkPVQ46zM=";
        };
      });
    };
  };
in

py.pkgs.buildPythonApplication (finalAttrs: {
  pname = "ggshield";
  version = "1.50.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GitGuardian";
    repo = "ggshield";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wwGj7i1GoxNzdfUhcL7mulgQAPtz5WhbT67hgbcMxpo=";
  };

  pythonRelaxDeps = true;

  build-system = with py.pkgs; [ hatchling ];

  dependencies = with py.pkgs; [
    charset-normalizer
    click
    cryptography
    keyring
    marshmallow
    marshmallow-dataclass
    notify-py
    oauthlib
    platformdirs
    pygitguardian
    pyjwt
    python-dotenv
    pyyaml
    requests
    rich
    sigstore
    truststore
    typing-extensions
    urllib3
  ];

  nativeCheckInputs = [
    git
  ]
  ++ (with py.pkgs; [
    jsonschema
    pyfakefs
    pytest-factoryboy
    pytest-mock
    pytest-voluptuous
    pytestCheckHook
    syrupy
    vcrpy
  ]);

  pythonImportsCheck = [ "ggshield" ];

  disabledTestPaths = [
    # Don't run functional tests
    "tests/functional/"
    "tests/unit/cmd/honeytoken"
    "tests/unit/cmd/scan/"
    "tests/test_factories.py"
  ];

  disabledTests = [
    # No TLS certificate, no .git folder, etc.
    "test_cache_catches"
    "test_is_git_dir"
    "test_is_valid_git_commit_ref"
    "test_check_git_dir"
    "test_does_not_fail_if_cache"
    # Encoding issues
    "test_create_files_from_paths"
    "test_file_decode_content"
    "test_file_is_longer_than_does_not_read_utf8_file"
    "test_file_is_longer_using_8bit_codec"
    "test_generate_files_from_paths"
    # Nixpkgs issue
    "test_get_file_sha_in_ref"
  ];

  meta = {
    description = "Tool to find and fix various types of hardcoded secrets and infrastructure-as-code misconfigurations";
    homepage = "https://github.com/GitGuardian/ggshield";
    changelog = "https://github.com/GitGuardian/ggshield/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ggshield";
  };
})
