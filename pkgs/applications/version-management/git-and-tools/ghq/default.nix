{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ghq";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "x-motemen";
    repo = "ghq";
    rev = "v${version}";
    sha256 = "1gfpvaf10kqgxx1clzsn38n9r4p171zf0z1pf0dybihh6g6hgylj";
  };

  vendorSha256 = "0k2hhx3l3cj3lv2y4w8286sbl7d11cssb99jy7hzskbxbhmalvcj";

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
    homepage = "https://github.com/x-motemen/ghq";
    maintainers = with stdenv.lib.maintainers; [ sigma ];
    license = stdenv.lib.licenses.mit;
  };
}