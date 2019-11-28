{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.60.0";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner  = "gohugoio";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0g8rq79xp7c9p31xc0anfjyz7xp8n7qzv3vmvg2nmzl7nayg88aa";
  };

  modSha256 = "12h1ik1hgs4lkmk699wpa34rnycnm03qyr2vp1y5lywz1h93by20";

  buildFlags = "-tags extended";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux ];
  };
}
