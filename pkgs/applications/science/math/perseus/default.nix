{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "perseus-4-beta";
  version = "4-beta";
  buildInputs = [ unzip ];

  hardeningDisable = [ "stackprotector" ];

  src = fetchurl {
    url = "http://www.sas.upenn.edu/~vnanda/source/perseus_4_beta.zip";
    sha256 = "09brijnqabhgfjlj5wny0bqm5dwqcfkp1x5wif6yzdmqh080jybj";
  };

  sourceRoot = ".";

  buildPhase = ''
    g++ Pers.cpp -O3 -fpermissive -o perseus
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp perseus $out/bin
  '';

  meta = {
    description = "The Persistent Homology Software";
    longDescription = ''
      Persistent homology - or simply, persistence - is an algebraic
      topological invariant of a filtered cell complex. Perseus
      computes this invariant for a wide class of filtrations built
      around datasets arising from point samples, images, distance
      matrices and so forth.
    '';
    homepage = http://www.sas.upenn.edu/~vnanda/perseus/index.html;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [erikryb];
    platforms = stdenv.lib.platforms.linux;
  };
}
