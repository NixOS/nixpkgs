{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghq";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "1i0q9lxdxbyj0l0510cbkwkbycawrx8cxlbdrhb2p2fnk0vqnyiv";
  };

  modSha256 = "0hlbhky3c6zva9khn73n6xgq57k5p8anskxy3g2m0wzhr72cyc41";

  buildFlagsArray = ''
    -ldflags=
      -X=main.Version=${version}
  '';

  postInstall = ''
    install -m 444 -D ${src}/misc/zsh/_ghq $out/share/zsh/site-functions/_ghq
    install -m 444 -D ${src}/misc/bash/_ghq $out/share/bash-completion/completions/_ghq
  '';

  meta = {
    description = "Remote repository management made easy";
    homepage = https://github.com/x-motemen/ghq;
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    license = stdenv.lib.licenses.mit;
  };
}
