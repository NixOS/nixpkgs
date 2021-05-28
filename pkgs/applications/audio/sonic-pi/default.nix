{ mkDerivation
, lib
, qtbase
, fetchFromGitHub
, fftwSinglePrec
, ruby
, aubio
, cmake
, pkgconfig
, boost
, bash
, jack2Full
, supercollider
, qwt
, osmid
}:

let

  supercollider_single_prec = supercollider.override {  fftw = fftwSinglePrec; };

in

mkDerivation rec {
  version = "3.2.2";
  pname = "sonic-pi";

  src = fetchFromGitHub {
    owner = "samaaron";
    repo = "sonic-pi";
    rev = "v${version}";
    sha256 = "1nlkpkpg9iz2hvf5pymvk6lqhpdpjbdrvr0hrnkc3ymj7llvf1cm";
  };

  buildInputs = [
    bash
    cmake
    pkgconfig
    qtbase
    qwt
    ruby
    aubio
    supercollider_single_prec
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
      cp -f utils/ruby_help.tmpl utils/ruby_help.h
      ../../server/ruby/bin/qt-doc.rb -o utils/ruby_help.h

      lrelease lang/*.ts

      mkdir build
      pushd build
        cmake -G "Unix Makefiles" ..
        make
      popd
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r {bin,etc} $out/

    # Copy server whole.
    mkdir -p $out/app
    cp -r app/server $out/app/

    # Copy only necessary files for the gui app.
    mkdir -p $out/app/gui/qt/build
    cp -r app/gui/qt/{book,fonts,help,html,images,image_source,info,lang,theme} $out/app/gui/qt/
    cp app/gui/qt/build/sonic-pi $out/app/gui/qt/build/sonic-pi

    runHook postInstall
  '';

  # $out/bin/sonic-pi is a shell script, and wrapQtAppsHook doesn't wrap them.
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/sonic-pi" \
      --prefix PATH : ${ruby}/bin:${bash}/bin:${supercollider}/bin:${jack2Full}/bin \
      --set AUBIO_LIB "${aubio}/lib/libaubio.so"
  '';

  meta = {
    homepage = "https://sonic-pi.net/";
    description = "Free live coding synth for everyone originally designed to support computing and music lessons within schools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Phlogistique kamilchm c0deaddict ];
    platforms = lib.platforms.linux;
  };
}
