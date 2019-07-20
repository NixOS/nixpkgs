{ stdenv, lib, buildPackages, buildGoPackage, fetchFromGitHub }:

let isCrossBuild = stdenv.hostPlatform != stdenv.buildPlatform; in

buildGoPackage rec {
  name = "stern-${version}";
  version = "1.11.0";

  goPackagePath = "github.com/wercker/stern";

  src = fetchFromGitHub {
    owner = "wercker";
    repo = "stern";
    rev = "${version}";
    sha256 = "0xndlq0ks8flzx6rdd4lnkxpkbvdy9sj1jwys5yj7p989ls8by3n";
  };

  goDeps = ./deps.nix;

  postInstall =
    let stern = if isCrossBuild then buildPackages.stern else "$bin"; in
    ''
      mkdir -p $bin/share/bash-completion/completions
      ${stern}/bin/stern --completion bash > $bin/share/bash-completion/completions/stern
      mkdir -p $bin/share/zsh/site-functions
      ${stern}/bin/stern --completion zsh > $bin/share/zsh/site-functions/_stern
    '';

  meta = with lib; {
    description      = "Multi pod and container log tailing for Kubernetes";
    homepage         = "https://github.com/wercker/stern";
    license          = licenses.asl20;
    maintainers      = with maintainers; [ mbode ];
    platforms        = platforms.unix;
  };
}
