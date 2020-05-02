{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "17v760mh5k5vb1h3xvaph5rfc5wdl6q42isil2k9n6y8bxr3yw84";
  };

  cargoSha256 = "1m659i3v3b5hfn5vb5126izcy690bkmlyihz2w90h2d02ig7170p";

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
