{ stdenv, fetchFromGitHub, fetchpatch
, audiofile, libvorbis, fltk, fftw, fftwFloat
, minixml, pkgconfig, libmad, libjack2, portaudio, libsamplerate
}:

stdenv.mkDerivation {
  pname = "paulstretch";
  version = "2.2-2";

  src = fetchFromGitHub {
    owner = "paulnasca";
    repo = "paulstretch_cpp";
    rev = "7f5c3993abe420661ea0b808304b0e2b4b0048c5";
    sha256 = "06dy03dbz1yznhsn0xvsnkpc5drzwrgxbxdx0hfpsjn2xcg0jrnc";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    audiofile
    libvorbis
    fltk
    fftw
    fftwFloat
    minixml
    libmad
    libjack2
    portaudio
    libsamplerate
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/paulnasca/paulstretch_cpp/pull/12.patch";
      sha256 = "0lx1rfrs53afkiz1drp456asqgj5yv6hx3lkc01165cv1jsbw6q4";
    })
  ];

  buildPhase = ''
    bash compile_linux_fftw_jack.sh
  '';

  installPhase = ''
    install -Dm555 ./paulstretch $out/bin/paulstretch
  '';

  meta = with stdenv.lib; {
    description = "Produces high quality extreme sound stretching";
    longDescription = ''
      This is a program for stretching the audio. It is suitable only for
      extreme sound stretching of the audio (like 50x) and for applying
      special effects by "spectral smoothing" the sounds.
      It can transform any sound/music to a texture.
    '';
    homepage = http://hypermammut.sourceforge.net/paulstretch/;
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
