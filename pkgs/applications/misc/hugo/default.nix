{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.62.0";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0z14qhsjgwqgm7kj25y0zh4b42bwd7zhcmwjxzkk6chzw7fwq375";
  };

  modSha256 = "0dwv5qnglv00jj7vlps76zlfpkzsplf93401j2l03xfvmvadifrs";

  buildFlags = "-tags extended";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 ];
  };
}
