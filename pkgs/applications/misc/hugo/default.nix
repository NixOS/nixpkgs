{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.47.1";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner  = "gohugoio";
    repo   = "hugo";
    rev    = "v${version}";
    sha256 = "0n27vyg66jfx4lwswsmdlybly8c9gy5rk7yhy7wzs3rwzlqv1jzj";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/gohugoio/hugo/commit/b137ad4dbd6d14d0a9af68c044aaee61f2c87fe5.diff";
      sha256 = "0w1gpg11idqywqcpwzvx4xabn02kk8y4jmyz4h67mc3yh2dhq3ll";
    })
  ];

  goDeps = ./deps.nix;

  buildFlags = "-tags extended";

  postInstall = ''
    rm $bin/bin/generate
  '';

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux ];
  };
}
