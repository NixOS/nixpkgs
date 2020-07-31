{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "hugo";
  version = "0.74.3";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0rikr4yrjvmrv8smvr8jdbcjqwf61y369wn875iywrj63pyr74r9";
  };

  vendorSha256 = "17xn6bdy942g6nx5xky41ixmd5kaz68chj3rb02ibpyraamx04nm";
  runVend = true;

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 Frostman ];
  };
}
