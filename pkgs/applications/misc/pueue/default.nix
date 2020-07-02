{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "0x8slqxpnk4pis834g11wzp8fqsxwhdf0xnssz1pkkww4dqzali0";
  };

  cargoSha256 = "0r110zlzpzg0j5cq9zg0kk46qigp6bzd0kzmpx3ddvhblhxvq5m5";

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
