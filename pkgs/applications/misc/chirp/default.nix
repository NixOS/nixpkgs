{ stdenv, fetchurl, libxml2Python, libxslt, makeWrapper
, pyserial, pygtk }:

stdenv.mkDerivation rec {
  name = "chirp-daily-${version}";
  version = "20180906";

  src = fetchurl {
    url = "https://trac.chirp.danplanet.com/chirp_daily/daily-${version}/${name}.tar.gz";
    sha256 = "00cq15892p46z1j1fl2pd17y7k4rc6cfz7gaxb446mshxrvbfgam";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    pyserial pygtk libxml2Python libxslt pyserial
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/chirp
    cp -r . $out/share/chirp/
    ln -s $out/share/chirp/chirpw $out/bin/chirpw

    for file in "$out"/bin/*; do
      wrapProgram "$file" \
        --prefix PYTHONPATH : $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with stdenv.lib; {
    description = "A free, open-source tool for programming your amateur radio";
    homepage = https://chirp.danplanet.com/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
