{ stdenv, buildGoModule, fetchFromGitHub, libsass }:

buildGoModule rec {
  pname = "hugo";
  version = "0.73.0";

  buildInputs = [ libsass ];

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qhv8kdv5k1xfk6106lxvsz7f92k7w6wk05ngz7qxbkb6zkcnshw";
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

  vendorSha256 = "07dkmrldsxw59v6r4avj1gr4hsaxybhb14qv61hc777qix2kq9v1";

  buildFlags = [ "-tags" "extended" ];

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = "https://gohugo.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux filalex77 Frostman ];
  };
}
