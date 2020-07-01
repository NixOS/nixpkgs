{ stdenv, lib, buildPackages, buildGoPackage, fetchFromGitHub, installShellFiles }:

let isCrossBuild = stdenv.hostPlatform != stdenv.buildPlatform; in

buildGoPackage rec {
  pname = "stern";
  version = "1.11.0";

  goPackagePath = "github.com/wercker/stern";

  src = fetchFromGitHub {
    owner = "wercker";
    repo = "stern";
    rev = version;
    sha256 = "0xndlq0ks8flzx6rdd4lnkxpkbvdy9sj1jwys5yj7p989ls8by3n";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ installShellFiles ];

  postInstall =
    let stern = if isCrossBuild then buildPackages.stern else "$out"; in
    ''
      for shell in bash zsh; do
        ${stern}/bin/stern --completion $shell > stern.$shell
        installShellCompletion stern.$shell
      done
    '';

  meta = with lib; {
    description      = "Multi pod and container log tailing for Kubernetes";
    homepage         = "https://github.com/wercker/stern";
    license          = licenses.asl20;
    maintainers      = with maintainers; [ mbode ];
    platforms        = platforms.unix;
  };
}
