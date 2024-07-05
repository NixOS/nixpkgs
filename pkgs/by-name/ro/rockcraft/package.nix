{ lib
, python3Packages
, fetchFromGitHub
, dpkg
, nix-update-script
, python3
}:

python3Packages.buildPythonApplication rec {
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
  '';

  propagatedBuildInputs = with python3Packages; [
    craft-application-1
    craft-archives
    spdx-lookup
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-check
    pytest-mock
    pytest-subprocess
    pytestCheckHook
  ] ++ [
    dpkg
  ];

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
