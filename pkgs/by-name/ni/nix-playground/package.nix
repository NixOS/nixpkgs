{
  cacert,
  fetchFromGitHub,
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "nix-playground";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "nix-playground";
    tag = version;
    hash = "sha256-WiQlqQHW4RNvk79cs3B6+Tg1STYXj2tq2+Pvu82saxk=";
  };

  build-system = with python3.pkgs; [
    hatchling
  ];

  dependencies = with python3.pkgs; [
    click
    pygit2
    rich
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Disable tests that require nix store
    "tests/acceptance/"
  ];

  # Tests require certificates
  # https://github.com/NixOS/nixpkgs/pull/72544#issuecomment-582674047
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  pythonImportsCheck = [ "nix_playground" ];

  meta = {
    description = "Command line tools for patching nixpkgs package source code easily";
    mainProgram = "np";
    homepage = "https://github.com/LaunchPlatform/nix-playground";
    changelog = "https://github.com/LaunchPlatform/nix-playground/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
