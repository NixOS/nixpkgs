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

  golibsass = fetchFromGitHub {
    owner = "bep";
    repo = "golibsass";
    rev = "8a04397f0baba474190a9f58019ff499ec43057a";
    sha256 = "0xk3m2ynbydzx87dz573ihwc4ryq0r545vz937szz175ivgfrhh3";
  };

  overrideModAttrs = (_: {
      postBuild = ''
      rm -rf vendor/github.com/bep/golibsass/
      cp -r --reflink=auto ${golibsass} vendor/github.com/bep/golibsass
      '';
    });

  vendorSha256 = "031k8bvca1pb1naw922vg5h95gnwp76dii1cjcs0b1qj93isdibk";

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 Frostman ];
  };
}
