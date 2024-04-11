{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Misterio77";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SOsHvcfDdUpb0x5VZ1vZJnGaIiWWOPgnAwKYNXzfUfI=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  cargoHash = "sha256-aimPeGIE5jP0pdrqwnzUzBqW0jz9+kcfpLdCN0r30xU=";

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
    maintainers = with maintainers; [ moni misterio77 ];
    mainProgram = "flavours";
  };
}
