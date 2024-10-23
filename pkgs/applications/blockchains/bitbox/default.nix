{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  clang,
  go,
  qtwebengine,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "bitbox";
  version = "4.44.1";

  src = fetchFromGitHub {
    owner = "BitBoxSwiss";
    repo = "bitbox-wallet-app";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-BaQzy0XL9Rd/uRvKeK5yRGl6g9HF69TBCgJ+t7d7lDY=";
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
    npmDepsHash = "sha256-DylU/32t70r/wgjMDBMbaS7egU5DHx7ST7MlZp2zPiw=";
    installPhase = "cp -r build $out";
  };

  buildPhase = ''
    runHook preBuild

    ln -s ${passthru.web} frontends/web/build
    export GOCACHE=$TMPDIR/go-cache
    make -C frontends/qt/server linux
    make -C frontends/qt base

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

  buildInputs = [ qtwebengine ];

  nativeBuildInputs = [
    clang
    go
    wrapQtAppsHook
  ];

  meta = with lib; {
    description = "Companion app for the BitBox02 hardware wallet";
    homepage = "https://bitbox.swiss/app/";
    license = licenses.asl20;
    mainProgram = "bitbox";
    maintainers = [ maintainers.tensor5 ];
    platforms = [ "x86_64-linux" ];
  };
}
