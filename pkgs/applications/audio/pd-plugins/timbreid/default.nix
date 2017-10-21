{ stdenv, fetchurl, unzip, puredata }:

stdenv.mkDerivation rec {
  version = "0.6.0";
  name = "timbreid-${version}";

  src = fetchurl {
    url = "http://williambrent.conflations.com/pd/timbreID-${version}-src.zip";
    sha256 = "02rnkb0vpjxrr60c3hryv7zhyjpci2mi9dk27kjxpj5zp26gjk0p";
  };

  buildInputs = [ unzip puredata ];

  unpackPhase = ''
    unzip $src
    mv timbreID-0.6.0-src/tID/* .
    rm -rf timbreID-0.6.0-src/tID/
    rm -rf timbreID-0.6.0-src/INSTALL.txt
  '';

  installPhase = ''
    mkdir -p $out/
    cp -r *.pd $out/
    cp -r *.pd_linux $out/
    cp -r *.wav $out/
  '';

  meta = {
    description = "A collection of audio feature analysis externals for puredata";
    homepage = http://williambrent.conflations.com/pages/research.html;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
