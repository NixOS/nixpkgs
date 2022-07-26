{ lib, stdenv, fetchurl, haskell, spass }:

stdenv.mkDerivation rec {
  pname = "system-for-automated-deduction";
  version = "2.3.25";
  src = fetchurl {
    url = "http://nevidal.org/download/sad-${version}.tar.gz";
    sha256 = "10jd93xgarik7xwys5lq7fx4vqp7c0yg1gfin9cqfch1k1v8ap4b";
  };
  buildInputs = [ haskell.compiler.ghc844 spass ];
  patches = [
    ./patch.patch
    # Since the LTS 12.0 update, <> is an operator in Prelude, colliding with
    # the <> operator with a different meaning defined by this package
    ./monoid.patch
  ];
  postPatch = ''
    substituteInPlace Alice/Main.hs --replace init.opt $out/init.opt
  '';
  installPhase = ''
    mkdir -p $out/{bin,provers}
    install alice $out/bin
    install provers/moses $out/provers
    substituteAll provers/provers.dat $out/provers/provers.dat
    substituteAll init.opt $out/init.opt
    cp -r examples $out
  '';
  inherit spass;
  meta = {
    description = "A program for automated proving of mathematical texts";
    longDescription = ''
      The system for automated deduction is intended for automated processing of formal mathematical texts
      written in a special language called ForTheL (FORmal THEory Language) or in a traditional first-order language
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.schmitthenner ];
    homepage = "http://nevidal.org/sad.en.html";
    platforms = lib.platforms.linux;
    broken = true; # ghc-8.4.4 is gone from Nixpkgs
  };
}
