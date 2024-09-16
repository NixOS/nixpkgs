{
  lib,
  python3,
  fetchFromGitHub,
  dpkg,
  nix-update-script,
}:

let
  python = python3.override {
    self = python;
    packageOverrides = self: super: {
      craft-application = super.craft-application.overridePythonAttrs (old: rec {
        version = "1.2.1";
        src = fetchFromGitHub {
          owner = "canonical";
          repo = "craft-application";
          rev = "refs/tags/${version}";
          hash = "sha256-CXZEWVoE66dlQJp4G8tinufjyaDJaH1Muxz/qd/81oA=";
        };
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace-fail "setuptools==67.7.2" "setuptools"
        '';
        preCheck = ''
          export HOME=$(mktemp -d)
        '';
      });
      pydantic-yaml = super.pydantic-yaml.overridePythonAttrs (old: rec {
        version = "0.11.2";
        src = fetchFromGitHub {
          owner = "NowanIlfideme";
          repo = "pydantic-yaml";
          rev = "refs/tags/v${version}";
          hash = "sha256-AeUyVav0/k4Fz69Qizn4hcJKoi/CDR9eUan/nJhWsDY=";
        };
        dependencies = with self; [
          deprecated
          importlib-metadata
          pydantic_1
          ruamel-yaml
          types-deprecated
        ];
      });
    };
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "rockcraft";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "rockcraft";
    rev = "refs/tags/${version}";
    hash = "sha256-Qk7Fi4I/5TCf9llGTsTBQsAxUkeVmAlH6tFNYMsyZ1c=";
  };

  postPatch = ''
    substituteInPlace rockcraft/__init__.py \
      --replace-fail "dev" "${version}"

    substituteInPlace rockcraft/utils.py \
      --replace-fail "distutils.util" "setuptools.dist"
  '';

  build-system = with python.pkgs; [ setuptools-scm ];

  dependencies = with python.pkgs; [
    craft-application
    craft-archives
    spdx-lookup
  ];

  nativeCheckInputs =
    with python.pkgs;
    [
      pytest-check
      pytest-mock
      pytest-subprocess
      pytestCheckHook
    ]
    ++ [ dpkg ];

  preCheck = ''
    mkdir -p check-phase
    export HOME="$(pwd)/check-phase"
  '';

  disabledTests = [ "test_expand_extensions" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "rockcraft";
    description = "Create OCI images using the language from Snapcraft and Charmcraft";
    homepage = "https://github.com/canonical/rockcraft";
    changelog = "https://github.com/canonical/rockcraft/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
