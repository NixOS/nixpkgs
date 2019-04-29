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
, alsaLib
, libX11
}:

let
  supercollider = libsForQt5.callPackage ../../../development/interpreters/supercollider {
    fftw = fftwSinglePrec;
  };

  # sonic-pi uses a specific version of osmid:
  # https://github.com/samaaron/sonic-pi/blob/0fff19db99350ab143a3a5c3e353c73555ca3574/app/gui/qt/build-debian-app#L12
  osmid = stdenv.mkDerivation rec {
    name = "osmid";

    src = fetchFromGitHub {
      owner = "llloret";
      repo = "osmid";
      rev = "391f35f789f18126003d2edf32902eb714726802";
      sha256 = "sha256:0v5pm5fpz7ckrvz7w2r74nkkvyhjdhl7k12p6vj5n67xf9wvq3ib";
    };

    buildInputs = [ cmake alsaLib libX11 ];

    installPhase = ''
      mkdir -p $out/bin
      cp {m2o,o2m} $out/bin/
    '';
  };

in stdenv.mkDerivation rec {
  version = "3.1.0";
  name = "sonic-pi-${version}";

  src = fetchFromGitHub {
    owner = "samaaron";
    repo = "sonic-pi";
    rev = "v${version}";
    sha256 = "0gi4a73szaa8iz5q1gxgpsnyvhhghcfqm6bfwwxbix4m5csbfgh9";
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
    export OSMID_DIR=app/server/native/osmid

    mkdir -p $OSMID_DIR
    cp ${osmid}/bin/{m2o,o2m} $OSMID_DIR

    pushd app/server/ruby/bin
      ./compile-extensions.rb
      ./i18n-tool.rb -t
    popd

    pushd app/gui/qt
      cp -f ruby_help.tmpl ruby_help.h
      ../../server/ruby/bin/qt-doc.rb -o ruby_help.h

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
