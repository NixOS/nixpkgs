{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "Softsun2";
    repo = pname;
    rev = "54a4538b1942535759d7670af338e63374d183df";
    sha256 = "1z9k0f196l1p6mp32cqgi6b3lagnc55n7bl52nax9lbrhr4vhvcd";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  cargoSha256 = "sha256-XiVIr2x7+mrkx5r95rQvBLyJL0uyqBGrNNTVuIIrSwY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd flavours \
      --zsh <($out/bin/flavours --completions zsh) \
      --fish <($out/bin/flavours --completions fish) \
      --bash <($out/bin/flavours --completions bash)
  '';

  meta = with lib; {
    description = "An easy to use base16 scheme manager/builder that integrates with any workflow";
    homepage = "https://github.com/Softsun2/flavours";
    changelog = "https://github.com/Softsun2/flavours/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
