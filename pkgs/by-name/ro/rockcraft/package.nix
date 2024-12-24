{
  lib,
  python3Packages,
  fetchFromGitHub,
  dpkg,
  nix-update-script,
}:

python3Packages.buildPythonApplication rec {
  pname = "rockcraft";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "rockcraft";
    rev = "1d87e33cf207b3a2f16eb125743ec11546fa0cb1";
    hash = "sha256-QnW3BMu4Tuvj8PCt5eYJbNMiojXpyJ1uza6hpMxxSOE=";
  };

  postPatch = ''
    substituteInPlace rockcraft/__init__.py \
      --replace-fail "dev" "${version}"

    substituteInPlace rockcraft/utils.py \
      --replace-fail "distutils.util" "setuptools.dist"
  '';

  build-system = with python3Packages; [ setuptools-scm ];

  dependencies = with python3Packages; [
    craft-application
    craft-archives
    craft-platforms
    spdx-lookup
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      craft-platforms
      pytest-check
      pytest-mock
      pytest-subprocess
      pytestCheckHook
      tabulate
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
