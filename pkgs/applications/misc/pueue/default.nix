{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qp9h1xlfxwswcqi1qn2hfybxl547z13xjbvfgsx1nc8yj51bi3c";
  };

  nativeBuildInputs = [ installShellFiles ];

  cargoSha256 = "00va292bjdp42bkqdkjqajmzc2nshhqa1fj0yfwdf3rrx4nhssjd";

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
