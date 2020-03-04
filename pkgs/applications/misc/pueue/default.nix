{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "03aj4vw8kvwqk1i1a4kah5b574ahs930ij7xmqsvdy7f8c2g6pbq";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoSha256 = "08zqhj3b0v4fxj8vi323zrxg4xvbp9gndm2khzs6daacglbwbvhk";

  postInstall = ''
    installShellCompletion utils/completions/pueue.{bash,fish} --zsh utils/completions/_pueue
  '';

  meta = with lib; {
    description = "A daemon for managing long running shell commands";
    homepage = "https://github.com/Nukesor/pueue";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
