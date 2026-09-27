{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lutgen";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    tag = "lutgen-v${finalAttrs.version}";
    hash = "sha256-8sayt1gLJPdhesUvSoykUYjIiGLRJH5avsRSrWLfIVE=";
  };

  cargoHash = "sha256-CJXobmGOFEOiycrtgKjupVwTCYLMQcEI7RdLGpwmSyg=";

  nativeBuildInputs = [ installShellFiles ];

  cargoBuildFlags = [
    "--bin"
    "lutgen"
  ];

  cargoTestFlags = [
    "-p"
    "lutgen-cli"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd lutgen \
      --bash <($out/bin/lutgen --bpaf-complete-style-bash) \
      --fish <($out/bin/lutgen --bpaf-complete-style-fish) \
      --zsh <($out/bin/lutgen --bpaf-complete-style-zsh)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^lutgen-v([0-9.]+)$" ];
  };

  meta = {
    description = "Blazingly fast interpolated LUT generator and applicator for arbitrary and popular color palettes";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    maintainers = with lib.maintainers; [
      ozwaldorf
      zzzsy
      donovanglover
    ];
    mainProgram = "lutgen";
    license = lib.licenses.mit;
  };
})
