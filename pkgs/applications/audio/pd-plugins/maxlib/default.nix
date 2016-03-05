{ stdenv, fetchurl, puredata }:

stdenv.mkDerivation rec {
  name = "maxlib-${version}";
  version = "1.5.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/pure-data/libraries/maxlib/${name}.tar.gz";
    sha256 = "0vxl9s815dnay5r0067rxsfh8f6jbk61f0nxrydzjydfycza7p1w";
  };

  buildInputs = [ puredata ];

  hardeningDisable = [ "format" ];

  patchPhase = ''
    for i in ${puredata}/include/pd/*; do
      ln -s $i .
    done
    sed -i "s@/usr@$out@g" Makefile
  '';

  postInstall = ''
    mv $out/local/lib/pd-externals/maxlib/ $out
    rm -rf $out/local/
  '';

  meta = {
    description = "A library of non-tilde externals for puredata, by Miller Puckette";
    homepage = http://puredata.info/downloads/maxlib;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
