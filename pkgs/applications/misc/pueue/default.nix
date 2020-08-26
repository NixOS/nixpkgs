{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ksks8c35q9aq5vnjxh480vqjyaa8c1fz1fb465vngnlyw762b22";
  };

  cargoSha256 = "0v1h4jhrzfb55zmpnbq18188rdvx7a7lvnjqh0w7cy90kvxssian";

  nativeBuildInputs = [ installShellFiles ];

  checkFlagsArray = [ "--skip=test_single_huge_payload" ];

  postInstall = ''
    # zsh completion generation fails. See: https://github.com/Nukesor/pueue/issues/57
    for shell in bash fish; do
      $out/bin/pueue completions $shell .
      installShellCompletion pueue.$shell
    done
  '';

  meta = with lib; {
    description = "A daemon for managing long running shell commands";
    homepage = "https://github.com/Nukesor/pueue";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
