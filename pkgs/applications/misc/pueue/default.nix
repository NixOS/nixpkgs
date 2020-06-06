{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n85b41kvx7x7qdizdnq1p0zrkap4gkwnnvhh4pz6j9njxj8d9ir";
  };

  cargoSha256 = "0hkkz74hllc5dzmgls6bgdxsdr871df2fn51sa3shv68ah0avxff";

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
