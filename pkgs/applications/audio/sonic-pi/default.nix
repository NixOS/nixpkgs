{ stdenv
, fetchFromGitHub
, fftwSinglePrec
, ruby
, libffi
, aubio
, cmake
, pkgconfig
, qt5
, libsForQt5
, boost
, bash
, makeWrapper
, jack2Full
}:

let
  supercollider = libsForQt5.callPackage ../../../development/interpreters/supercollider {
    fftw = fftwSinglePrec;
  };

in stdenv.mkDerivation rec {
  version = "3.0.1";
  name = "sonic-pi-${version}";

  src = fetchFromGitHub {
    owner = "samaaron";
    repo = "sonic-pi";
    rev = "v${version}";
    sha256 = "1l1892hijp1dj2h799sfjr699q6xp660n0siibab5kv238521a81";
  };

  buildInputs = [
    bash
    cmake
    makeWrapper
    pkgconfig
    qt5.qtbase
    libsForQt5.qscintilla
    libsForQt5.qwt
    ruby
    libffi
    aubio
    supercollider
    boost
  ];

  dontUseCmakeConfigure = true;

  preConfigure = ''
    patchShebangs .
    substituteInPlace app/gui/qt/mainwindow.cpp \
      --subst-var-by ruby "${ruby}/bin/ruby" \
      --subst-var out
  '';

  buildPhase = ''
    export SONIC_PI_HOME=$TMPDIR
    export AUBIO_LIB=${aubio}/lib/libaubio.so

    pushd app/server/bin
      ./compile-extensions.rb
      ./i18n-tool.rb -t
    popd

    pushd app/gui/qt
      cp -f ruby_help.tmpl ruby_help.h
      ../../server/bin/qt-doc.rb -o ruby_help.h

      substituteInPlace SonicPi.pro \
        --replace "LIBS += -lrt -lqt5scintilla2" \
                  "LIBS += -lrt -lqscintilla2 -lqwt"

      lrelease SonicPi.pro
      qmake SonicPi.pro 

      make
    popd
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out
    wrapProgram $out/bin/sonic-pi \
      --prefix PATH : ${ruby}/bin:${bash}/bin:${supercollider}/bin:${jack2Full}/bin \
      --set AUBIO_LIB "${aubio}/lib/libaubio.so"

    runHook postInstall
  '';

  meta = {
    homepage = http://sonic-pi.net/;
    description = "Free live coding synth for everyone originally designed to support computing and music lessons within schools";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ Phlogistique kamilchm ];
    platforms = stdenv.lib.platforms.linux;
  };
}
