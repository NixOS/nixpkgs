{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "050cx9ncs1hfb14llly0wm3h5s4377s3sinmkjc52xm2z2gc7m5f";
  };

  cargoSha256 = "1hw0y6c1ypp470cca3yw6fc7xvligy3av8hsa9bhdm5can46hyzi";

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
