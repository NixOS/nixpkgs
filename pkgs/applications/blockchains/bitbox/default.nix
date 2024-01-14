{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, clang
, go
, qtwebengine
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "bitbox";
  version = "4.40.0";

  src = fetchFromGitHub {
    owner = "digitalbitbox";
    repo = "bitbox-wallet-app";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-kvkfz9zwleZNB+leefx+cciJCPkFSSRDxBNRKNqeODc=";
  };

  patches = [
    ./genassets.patch
  ];

  postPatch = ''
    substituteInPlace frontends/qt/resources/linux/usr/share/applications/bitbox.desktop \
        --replace 'Exec=BitBox %u' 'Exec=bitbox %u'
  '';

  dontConfigure = true;

  passthru.web = buildNpmPackage {
    pname = "bitbox-web";
    inherit version;
    inherit src;
    sourceRoot = "source/frontends/web";
    npmDepsHash = "sha256-bnMmeSX8UZpndHK0NMLQhX1GSunO0JSyZdUTfG+rSpY=";
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
    platforms = platforms.unix;
  };
}
