{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.60.1";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l8n87y5zrs09s693rqvqwz0233wlr4jwib7r36ilss1qgm7x6n5";
  };

  modSha256 = "1an4plbx06fzz2iqzgs08r6vsjpkl5lbqck5jqmv6fv7b7psf7iw";

  buildFlags = "-tags extended";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 ];
  };
}
