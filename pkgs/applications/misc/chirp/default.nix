{ stdenv, fetchurl, libxml2Python, libxslt, makeWrapper
, python, pyserial, pygtk
}:
let
  version = "0.4.1";
in
stdenv.mkDerivation rec {
  name = "chirp-${version}";
  inherit version;

  src = fetchurl {
    url = "http://chirp.danplanet.com/download/0.4.1/chirp-${version}.tar.gz";
    sha256 = "17iihghqjprn2hld193qw0yl1kkrf6m0fp57l7ibkflxr0nnb7cc";
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
