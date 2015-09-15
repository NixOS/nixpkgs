args @ { makeWrapper, python, ... }: with args;
let version = if args ? version then args.version else "0.9.35"; in
rec {
  src = fetchurl {
    urls = [
      "http://darcs.arstecnica.it/tailor/tailor-${version}.tar.gz"
      "http://pkgs.fedoraproject.org/repo/pkgs/tailor/tailor-${version}.tar.gz/58a6bc1c1d922b0b1e4579c6440448d1/tailor-${version}.tar.gz"
    ];
    sha256 = "061acapxxn5ab3ipb5nd3nm8pk2xj67bi83jrfd6lqq3273fmdjh";
  };

  buildInputs = [python makeWrapper];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["installPythonPackage" "wrapBinContentsPython"];

  name = "tailor-" + version;
  meta = {
    description = "Version control tools integration tool";
  };
}

