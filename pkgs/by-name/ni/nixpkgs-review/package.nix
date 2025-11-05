{
  lib,
  python3Packages,
  fetchFromGitHub,

  installShellFiles,
  bubblewrap,
  nix-output-monitor,
  delta,
  glow,
  cacert,
  git,
  nix,
  versionCheckHook,

  withAutocomplete ? true,
  withSandboxSupport ? false,
  withNom ? false,
  withDelta ? false,
  withGlow ? false,
}:

python3Packages.buildPythonApplication rec {
  pname = "nixpkgs-review";
  version = "3.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    tag = version;
    hash = "sha256-43+H68OPABAqg9GQZJ+XehyWmUWk+EWiHzSxyc55luY=";
  };

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = lib.optionals withAutocomplete [
    python3Packages.argcomplete
  ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals withAutocomplete [
    python3Packages.argcomplete
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  makeWrapperArgs =
    let
      binPath = [
        nix
        git
      ]
      ++ lib.optional withSandboxSupport bubblewrap
      ++ lib.optional withNom nix-output-monitor
      ++ lib.optional withDelta delta
      ++ lib.optional withGlow glow;
    in
    [
      "--prefix PATH : ${lib.makeBinPath binPath}"
      "--set-default NIX_SSL_CERT_FILE ${cacert}/etc/ssl/certs/ca-bundle.crt"
      # we don't have any runtime deps but nixpkgs-review shells might inject unwanted dependencies
      "--unset PYTHONPATH"
    ];

  postInstall = lib.optionalString withAutocomplete ''
    for cmd in nix-review nixpkgs-review; do
      installShellCompletion --cmd $cmd \
        --bash <(register-python-argcomplete $cmd) \
        --fish <(register-python-argcomplete $cmd -s fish) \
        --zsh <(register-python-argcomplete $cmd -s zsh)
    done
  '';

  meta = {
    changelog = "https://github.com/Mic92/nixpkgs-review/releases/tag/${version}";
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-review";
    maintainers = with lib.maintainers; [
      mdaniels5757
      mic92
    ];
  };
}
