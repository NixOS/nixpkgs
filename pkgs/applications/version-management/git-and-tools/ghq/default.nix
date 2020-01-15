{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "ghq";
  version = "0.12.6";

  goPackagePath = "github.com/motemen/ghq";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "14rm7fvphr7r9x0ys10vhzjwhfhhscgr574n1i1z4lzw551lrnp4";
  };

  goDeps = ./deps.nix;

  buildFlagsArray = ''
    -ldflags=
      -X=main.Version=${version}
  '';

  postInstall = ''
    install -m 444 -D ${src}/zsh/_ghq $bin/share/zsh/site-functions/_ghq
  '';

  meta = {
    description = "Remote repository management made easy";
    homepage = https://github.com/motemen/ghq;
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    license = stdenv.lib.licenses.mit;
  };
}
