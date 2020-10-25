{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rqnbils0r98qglhm2jafw5d119fqdzszmk825yc0bma4icm7xzp";
  };

  cargoSha256 = "1f3g5i0yh82qll1hyihrvv08pbd4h9vzs6jy6bf94bzabyjsgnzv";

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "--skip=test_single_huge_payload" "--skip=test_create_unix_socket" ];

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
