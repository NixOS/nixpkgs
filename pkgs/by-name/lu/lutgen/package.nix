{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  installShellFiles,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "lutgen";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    tag = "lutgen-v${version}";
    hash = "sha256-ENhaJTbaAv52YFNjce9Ln/LQvP/Nw2Tk5eMmr8mKwQ0=";
  };

  cargoHash = "sha256-PEso+fTH1DndRUPULYIDMAqnrfz8W9iVVxZ7W2N/I5U=";

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

  meta = with lib; {
    description = "Blazingly fast interpolated LUT generator and applicator for arbitrary and popular color palettes";
    homepage = "https://github.com/ozwaldorf/lutgen-rs";
    maintainers = with maintainers; [
      ozwaldorf
      zzzsy
      donovanglover
    ];
    mainProgram = "lutgen";
    license = licenses.mit;
  };
}
