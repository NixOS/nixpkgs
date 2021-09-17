{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Misterio77";
    repo = pname;
    rev = "v${version}";
    sha256 = "1bgi6p7l0bh9k4vkwvngk7q19ynia0z1ninb1cq8qnwwpll6kbya";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  cargoSha256 = "07hwxhfcbqbwb3hz18w92h1lhdiwwy7abhwpimzx7syyavp4rmn4";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd flavours \
      --zsh <($out/bin/flavours --completions zsh) \
      --fish <($out/bin/flavours --completions fish) \
      --bash <($out/bin/flavours --completions bash)
  '';

  meta = with lib; {
    description = "An easy to use base16 scheme manager/builder that integrates with any workflow";
    homepage = "https://github.com/Misterio77/flavours";
    changelog = "https://github.com/Misterio77/flavours/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
