{
  lib,
  stdenv,
  buildPackages,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

let
  emulatorAvailable = stdenv.hostPlatform.emulatorAvailable buildPackages;
  emulator = stdenv.hostPlatform.emulator buildPackages;
in
rustPlatform.buildRustPackage {
  pname = "npingler";
  version = "unstable-2025-08-26";

  src = fetchFromGitHub {
    owner = "9999years";
    repo = "npingler";
    rev = "13781b1ee6a141dfebdaa4d885e153e1147a2312";
    hash = "sha256-cWWzXsxvsETm3+91PuRnR27hSZZWVKnWU3YiTvB+t6A=";
  };

  cargoHash = "sha256-71uqdWsXBd6qsplwI3cA2TxXoj6JOThEHxnv9u6iraQ=";


  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString emulatorAvailable ''
    installShellCompletion --cmd npingler \
      --bash <(${emulator} $out/bin/npingler util generate-completions bash) \
      --fish <(${emulator} $out/bin/npingler util generate-completions fish) \
      --zsh  <(${emulator} $out/bin/npingler util generate-completions zsh)
  '';

  meta = {
    description = "Nix profile manager for use with npins";
    homepage = "https://github.com/9999years/npingler";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers._9999years
    ];
    mainProgram = "npingler";
  };

  passthru.updateScript = nix-update-script { };
}
