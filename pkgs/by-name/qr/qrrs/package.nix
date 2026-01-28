{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:
rustPlatform.buildRustPackage rec {
  pname = "qrrs";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "lenivaya";
    repo = "qrrs";
    rev = "v${version}";
    hash = "sha256-lXfqKMJx9vtljQlYvbUAONFqMO3HKa4hx/29/YERw2U=";
  };

  cargoHash = "sha256-blBZOnrKdNfq010b6u1NmTLY3W9Q2BjQAVbW+oNbDlE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./man/*.?


    installShellCompletion --cmd qrrs \
      --bash <(cat ./completions/qrrs.bash) \
      --fish <(cat ./completions/qrrs.fish) \
      --zsh <(cat ./completions/_qrrs)
  '';

  meta = {
    maintainers = with lib.maintainers; [ lenivaya ];
    description = "CLI QR code generator and reader written in rust";
    license = lib.licenses.mit;
    homepage = "https://github.com/Lenivaya/qrrs";
    mainProgram = "qrrs";
  };
}
