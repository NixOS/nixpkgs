{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.61.0";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ad70g4gb44dk48pbgk48jzs44b6l7ksxb739ahp7vs1nyvvgffr";
  };

  modSha256 = "1jb1iqlp1005aj8smcgznmwnqaysi5g5wcsj8nvvm70hhc9j8wns";

  buildFlags = "-tags extended";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 ];
  };
}
