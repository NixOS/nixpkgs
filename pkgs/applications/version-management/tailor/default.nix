{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  name = "tailor-${version}";
  version = "0.9.35";

  src = fetchurl {
    urls = [
      "http://darcs.arstecnica.it/tailor/tailor-${version}.tar.gz"
      "http://pkgs.fedoraproject.org/repo/pkgs/tailor/tailor-${version}.tar.gz/58a6bc1c1d922b0b1e4579c6440448d1/tailor-${version}.tar.gz"
    ];
    sha256 = "061acapxxn5ab3ipb5nd3nm8pk2xj67bi83jrfd6lqq3273fmdjh";
  };

  meta = {
    description = "Version control tools integration tool";
  };
}

