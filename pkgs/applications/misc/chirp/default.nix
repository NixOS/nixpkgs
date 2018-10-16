{ stdenv, fetchurl, libxml2Python, libxslt, makeWrapper
, pyserial, pygtk }:

stdenv.mkDerivation rec {
  name = "chirp-daily-${version}";
  version = "20181009";

  src = fetchurl {
    url = "https://trac.chirp.danplanet.com/chirp_daily/daily-${version}/${name}.tar.gz";
    sha256 = "1h7i8skdjkz7n6dz3q9pzg1k31nh1ivy2mx3864bjvpkc7m6yyd9";
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
