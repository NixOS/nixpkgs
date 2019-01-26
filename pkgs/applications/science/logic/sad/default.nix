{ stdenv, fetchurl, ghc, spass }:

stdenv.mkDerivation {
  name = "system-for-automated-deduction-2.3.25";
  src = fetchurl {
    url = "http://nevidal.org/download/sad-2.3-25.tar.gz";
    sha256 = "10jd93xgarik7xwys5lq7fx4vqp7c0yg1gfin9cqfch1k1v8ap4b";
  };
  buildInputs = [ ghc spass ];
  patches = [
    ./patch
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
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.schmitthenner ];
    homepage = http://nevidal.org/sad.en.html;
    platforms = stdenv.lib.platforms.linux;
  };
}
