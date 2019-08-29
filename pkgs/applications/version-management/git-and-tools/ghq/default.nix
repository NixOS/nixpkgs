{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "ghq-${version}";
  version = "0.10.2";

  goPackagePath = "github.com/motemen/ghq";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "1i7zmgv7760nrw8sayag90b8vvmbsiifgiqki5s3gs3ldnvlki5w";
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
