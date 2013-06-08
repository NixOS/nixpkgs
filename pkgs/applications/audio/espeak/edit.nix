{stdenv, fetchurl, unzip, portaudio, wxGTK}:

stdenv.mkDerivation {
  name = "espeakedit-1.46.02";
  src = fetchurl {
    url = mirror://sourceforge/espeak/espeakedit-1.46.02.zip;
    sha256 = "1cc5r89sn8zz7b8wj4grx9xb7aqyi0ybj0li9hpy7hd67r56kqkl";
  };

  buildInputs = [ unzip portaudio wxGTK ];

  patchPhase = if portaudio.api_version == 19 then ''
    cp src/portaudio19.h src/portaudio.h
  '' else "";

  buildPhase = ''
    cd src
    gcc -o espeakedit *.cpp `wx-config --cxxflags --libs`
  '';

  installPhase = ''
    ensureDir $out/bin
    cp espeakedit $out/bin
  '';

  meta = {
    description = "Phoneme editor for espeak";
    homepage = http://espeak.sourceforge.net/;
    license = "GPLv3+";
  };
}
