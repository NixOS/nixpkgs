{ stdenv, fetchurl, libxml2Python, libxslt, makeWrapper
, python, pyserial, pygtk
}:
let
  version = "20160601";
in
stdenv.mkDerivation rec {
  name = "chirp-daily-${version}";
  inherit version;

  src = fetchurl {
    url = "http://trac.chirp.danplanet.com/chirp_daily/daily-${version}/chirp-daily-${version}.tar.gz";
    sha256 = "1zjrk0rrwiz5v86bd34snpjbajj2ikv95lfn4nnjdxgcdq9a3878";
  };

  buildInputs = [
    makeWrapper
    pyserial pygtk libxml2Python libxslt pyserial
  ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

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
