{ stdenv, fetchurl, libxml2Python, libxslt, makeWrapper
, python, pyserial, pygtk }:

stdenv.mkDerivation rec {
  name = "chirp-daily-${version}";
  version = "20180412";

  src = fetchurl {
    url = "http://trac.chirp.danplanet.com/chirp_daily/daily-${version}/${name}.tar.gz";
    sha256 = "17wpxqzifz6grw9xzg9q9vr58vm2xd50fhd64c3ngdhxcnq2dpj9";
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
    homepage = http://chirp.danplanet.com/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.the-kenny ];
  };
}
