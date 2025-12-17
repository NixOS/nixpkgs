{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  buildNpmPackage,
  clang,
  go_1_24,
  libsForQt5,
  qt6,
  udevCheckHook,
}:

let
  # Qt 6 doesn’t provide the rcc binary so we create an ad hoc package pulling
  # it from Qt 5.
  rcc = runCommand "rcc" { } ''
    mkdir -p $out/bin
    cp ${lib.getExe' libsForQt5.qt5.qtbase.dev "rcc"} $out/bin
  '';
in
stdenv.mkDerivation rec {
  pname = "bitbox";
  version = "4.49.0";

  src = fetchFromGitHub {
    owner = "BitBoxSwiss";
    repo = "bitbox-wallet-app";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-pl7vtRQCxRwG58bBnT8iAi2qfsdeJrHbzDeHJsYwjnQ=";
  };

  postPatch = ''
    substituteInPlace frontends/qt/resources/linux/usr/share/applications/bitbox.desktop \
        --replace-fail 'Exec=BitBox %u' 'Exec=bitbox %u'
  '';

  dontConfigure = true;

  passthru.web = buildNpmPackage {
    pname = "bitbox-web";
    inherit version;
    inherit src;
    sourceRoot = "${src.name}/frontends/web";
    npmDepsHash = "sha256-J3jT286MZGTHgmRXKiXj7lod9wgoEVQrCfOGCtSyG/s=";
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
    install -m 644 -Dt $out/lib/udev/rules.d ${./rules.d}/*

    runHook postInstall
  '';

  buildInputs = [ qt6.qtwebengine ];

  nativeBuildInputs = [
    clang
    go_1_24
    qt6.wrapQtAppsHook
    rcc
    udevCheckHook
  ];

  doInstallCheck = true;

  meta = {
    description = "Companion app for the BitBox02 hardware wallet";
    homepage = "https://bitbox.swiss/app/";
    downloadPage = "https://github.com/BitBoxSwiss/bitbox-wallet-app";
    changelog = "https://github.com/BitBoxSwiss/bitbox-wallet-app/blob/master/CHANGELOG.md#${
      builtins.replaceStrings [ "." ] [ "" ] version
    }";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.tensor5 ];
    mainProgram = "bitbox";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    platforms = [ "x86_64-linux" ];
  };
}
