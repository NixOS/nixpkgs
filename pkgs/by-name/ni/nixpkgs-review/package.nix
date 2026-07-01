# If adding a dependency that depends on nix, please make sure that the
# overrides in pkgs/tools/package-management/lix/default.nix are updated too.
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
  nix-eval-jobs,
  versionCheckHook,

  withAutocomplete ? true,
  withSandboxSupport ? false,
  withNom ? false,
  withDelta ? false,
  withGlow ? false,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nixpkgs-review";
  version = "3.9.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nixpkgs-review";
    tag = finalAttrs.version;
    hash = "sha256-u0DbEwe28csVWKbu8x9v9/Ah0ZUUgqXtZU2Rr5IJpWI=";
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

  makeWrapperArgs =
    let
      binPath = [
        nix
        nix-eval-jobs
        git
      ]
      ++ lib.optional withSandboxSupport bubblewrap
      ++ lib.optional withNom nix-output-monitor
      ++ lib.optional withDelta delta
      ++ lib.optional withGlow glow;
    in
    [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath binPath)
      "--set-default"
      "NIX_SSL_CERT_FILE"
      "${cacert}/etc/ssl/certs/ca-bundle.crt"
      # we don't have any runtime deps but nixpkgs-review shells might inject unwanted dependencies
      "--unset"
      "PYTHONPATH"
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
    changelog = "https://github.com/Mic92/nixpkgs-review/releases/tag/${finalAttrs.version}";
    description = "Review pull-requests on https://github.com/NixOS/nixpkgs";
    homepage = "https://github.com/Mic92/nixpkgs-review";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-review";
    maintainers = with lib.maintainers; [
      figsoda
      mdaniels5757
      mic92
    ];
  };
})
