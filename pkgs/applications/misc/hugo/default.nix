{ stdenv, buildGoModule, fetchFromGitHub, libsass }:

buildGoModule rec {
  pname = "hugo";
  version = "0.70.0";

  buildInputs = [ libsass ];

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "14g1x95jh91z9xm3xkv2psw2jn7z6bv2009miyv727df4d58nh6m";
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

  vendorSha256 = "1wl9pg5wf1n5n7gq6lyz0l5ij4icjpfinl4myxwj93l2hqqyx2lf";

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 Frostman ];
  };
}
