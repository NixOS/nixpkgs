{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.63.2";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "1fylsx2isvims0xwcj831b1zcwsmd3igrnxjad44rhl2k3anq8vm";
  };

  modSha256 = "0h95r3m6ca60dn1bllnw127nbfnkdjld94c3nyrzlwdczl2iaiyf";

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 ];
  };
}
