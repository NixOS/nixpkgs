{ mkDerivation
, lib
, qtbase
, fetchFromGitHub
, fftwSinglePrec
, ruby
, erlang
, aubio
, alsa-lib
, rtmidi
, libsndfile
, cmake
, pkg-config
, boost
, bash
, jack2
, supercollider
, qwt
}:

let

  supercollider_single_prec = supercollider.override {  fftw = fftwSinglePrec; };

  pname = "sonic-pi";
  version = "3.3.1";
  src = fetchFromGitHub {
    owner = "sonic-pi-net";
    repo = "sonic-pi";
    rev = "v${version}";
    sha256 = "sha256-AE7iuSNnW1SAtBMplReGzXKcqD4GG23i10MIAWnlcPo=";
  };

  # sonic pi uses it's own aubioonset with hardcoded parameters but will compile a whole aubio for it
  # let's just build the aubioonset instead and link against aubio from nixpkgs
  aubioonset = mkDerivation {
    name = "aubioonset";
    src = src;
    sourceRoot = "source/app/external/aubio/examples";
    buildInputs = [jack2 aubio libsndfile];
    patchPhase = ''
      sed -i "s@<aubio.h>@<aubio/aubio.h>@" jackio.c utils.h
    '';
    buildPhase = ''
      gcc -o aubioonset -laubio jackio.c utils.c aubioonset.c
    '';
    installPhase = ''
      install -D aubioonset $out/aubioonset
    '';
  };

in

mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    bash
    pkg-config
    qtbase
    qwt
    ruby
    aubio
    supercollider_single_prec
    boost
    erlang
    alsa-lib
    rtmidi
  ];

  dontUseCmakeConfigure = true;

  prePatch = ''
    sed -i '/aubio/d' app/external/linux_build_externals.sh
    sed -i '/aubio/d' app/linux-prebuild.sh
    patchShebangs app
  '';

  configurePhase = ''
    runHook preConfigure

    ./app/linux-prebuild.sh
    ./app/linux-config.sh

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    pushd app/build
    cmake --build . --config Release
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r {bin,etc} $out/

    # Copy server whole.
    mkdir -p $out/app
    cp -r app/server $out/app/

    # We didn't build this during linux-prebuild.sh so copy from the separate derivation
    cp ${aubioonset}/aubioonset $out/app/server/native/

    # Copy only necessary files for the gui app.
    mkdir -p $out/app/gui/qt
    cp -r app/gui/qt/{book,fonts,help,html,images,image_source,info,lang,theme} $out/app/gui/qt/
    mkdir -p $out/app/build/gui/qt
    cp app/build/gui/qt/sonic-pi $out/app/build/gui/qt/sonic-pi

    runHook postInstall
  '';

  # $out/bin/sonic-pi is a shell script, and wrapQtAppsHook doesn't wrap them.
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp "$out/bin/sonic-pi" \
      --prefix PATH : ${lib.makeBinPath [ bash jack2 ruby supercollider erlang] }
    makeWrapper \
      $out/app/server/ruby/bin/sonic-pi-server.rb \
      $out/bin/sonic-pi-server \
      --prefix PATH : ${lib.makeBinPath [ bash jack2 ruby supercollider erlang ] }
  '';

  meta = {
    homepage = "https://sonic-pi.net/";
    description = "Free live coding synth for everyone originally designed to support computing and music lessons within schools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Phlogistique kamilchm c0deaddict sohalt ];
    platforms = lib.platforms.linux;
  };
}
