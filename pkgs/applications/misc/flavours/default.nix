{ lib, stdenv, fetchFromGitHub, rustPlatform, libiconv, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "flavours";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Misterio77";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Q2YW9oFqzkmWscoE4p9E43bo1/4bQrTnd8tvPsJqJyQ=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  cargoSha256 = "sha256-IrVcd8ilWbaigGMqT+kaIW3gnE+m+Ik5IyhQ4zPlyPE=";

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
