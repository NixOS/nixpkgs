{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.65.3";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "1m0xhzm1w6y778x3fplzr9dif7lcqlkfvk4b7plywrisv3ic8yqs";
  };

  modSha256 = "1f320zbqnv2ybsp3qmlgn3rsjgp2zdb24qjd3gcys30mw48cx3na";

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 Frostman ];
  };
}
