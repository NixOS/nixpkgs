{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, clang
, go
, qtwebengine
, wrapQtAppsHook
}:

let
  src = fetchFromGitHub {
    owner = "digitalbitbox";
    repo = "bitbox-wallet-app";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Ct5qg/jRN/CwlRNZQNvoMM3yn1KycJZn/FsYwjrN2Os=";
  };
  version = "4.39.0";
  web = buildNpmPackage {
    pname = "bitbox-web";
    inherit version;
    inherit src;
    sourceRoot = "source/frontends/web";
    npmDepsHash = "sha256-5EgTWQRpBp34u6fWSmrPLoVbF/L1+p+sVO050YyexbU=";
    installPhase = "cp -r build $out";
  };
in
stdenv.mkDerivation {
  pname = "bitbox";
  inherit version;

  inherit src;

  patches = [
    ./desktop.patch
    ./genassets.patch
  ];

  dontConfigure = true;

  buildPhase = ''
    ln -s ${web} frontends/web/build
    export GOCACHE=$TMPDIR/go-cache
    make -C frontends/qt/server linux
    make -C frontends/qt base
  '';

  installPhase = ''
    mkdir $out
    cp -r frontends/qt/resources/linux/usr/share $out
    mkdir $out/{bin,lib}
    cp frontends/qt/build/BitBox $out/bin/bitbox
    cp frontends/qt/build/assets.rcc $out/bin
    cp frontends/qt/server/libserver.so $out/lib
    install -Dt $out/lib/udev/rules.d ${./rules.d}/*
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
    maintainers = [ maintainers.tensor5 ];
    platforms = platforms.unix;
  };
}
