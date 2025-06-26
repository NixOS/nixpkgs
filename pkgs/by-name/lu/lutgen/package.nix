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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ozwaldorf";
    repo = "lutgen-rs";
    tag = "lutgen-v${version}";
    hash = "sha256-hJ5yD8Yu08kcr2rWY59iVEFJH+chroEWSsP2g5agFuo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-VsKRLxh6uRG2A5AvJBMdD+bXg/X9mp5o1iPR9MZhrbQ=";

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
