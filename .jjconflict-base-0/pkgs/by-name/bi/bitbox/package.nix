{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  clang,
  go,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "bitbox";
  version = "4.46.3";

  src = fetchFromGitHub {
    owner = "BitBoxSwiss";
    repo = "bitbox-wallet-app";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-2oGVQ022NGOHLo7TBdeXG3ng1nYW8fyLwSV0hJdAl9I=";
  };

  patches = [
    ./genassets.patch
  ];

  postPatch = ''
    substituteInPlace frontends/qt/resources/linux/usr/share/applications/bitbox.desktop \
        --replace-fail 'Exec=BitBox %u' 'Exec=bitbox %u'
  '';

  dontConfigure = true;

  passthru.web = buildNpmPackage {
    pname = "bitbox-web";
    inherit version;
    inherit src;
    sourceRoot = "source/frontends/web";
    npmDepsHash = "sha256-w98wwKHiZtor5ivKd+sh5K8HnAepu6cw9RyVJ+eTq3k=";
    installPhase = "cp -r build $out";
  };

  buildPhase = ''
    runHook preBuild

    ln -s ${passthru.web} frontends/web/build
    export GOCACHE=$TMPDIR/go-cache
    cd frontends/qt
    make -C server linux
    ./genassets.sh
    qmake -o build/Makefile
    cd build
    make
    cd ../../..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r frontends/qt/resources/linux/usr/share $out
    mkdir $out/{bin,lib}
    cp frontends/qt/build/BitBox $out/bin/bitbox
    cp frontends/qt/build/assets.rcc $out/bin
    cp frontends/qt/server/libserver.so $out/lib
    install -Dt $out/lib/udev/rules.d ${./rules.d}/*

    runHook postInstall
  '';

  buildInputs = [ libsForQt5.qtwebengine ];

  nativeBuildInputs = [
    clang
    go
    libsForQt5.wrapQtAppsHook
  ];

  meta = {
    description = "Companion app for the BitBox02 hardware wallet";
    homepage = "https://bitbox.swiss/app/";
    license = lib.licenses.asl20;
    mainProgram = "bitbox";
    maintainers = [ lib.maintainers.tensor5 ];
    platforms = [ "x86_64-linux" ];
  };
}
