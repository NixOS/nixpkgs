{ stdenv, fetchurl, unzip, puredata }:

stdenv.mkDerivation rec {
  name = "puremapping-1.01";

  src = fetchurl {
    url = "http://www.chnry.net/ch/IMG/zip/puremapping-libdir-generic.zip";
    name = "puremapping";
    sha256 = "1ygzxsfj3rnzjkpmgi4wch810q8s5vm1gdam6a938hbbvamafgvc";
  };

  buildInputs = [ unzip puredata ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/puremapping
    mv puremapping/ $out
  '';

  meta = {
    description = "Set of externals to facilitate the use of sensors within Pure Data and to create complex relations between input and output of a dynamic system";
    homepage = http://www.chnry.net/ch/?090-Pure-Mapping&lang=en;
    license = stdenv.lib.licenses.gpl1;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
