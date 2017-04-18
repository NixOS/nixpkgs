{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "ghq-${version}";
  version = "0.7.4";

  goPackagePath = "github.com/motemen/ghq";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "0x2agr7why8mcjhq2j8kh8d0gbwx2333zgf1ribc9fn14ryas1j2";
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
