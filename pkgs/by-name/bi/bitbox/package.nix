{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  buildNpmPackage,
  callPackage,
  clang,
  go,
  qt5,
  qt6,
  udevCheckHook,
}:

let
  breez-sdk-spark = callPackage ./breez-sdk-spark.nix { };

  # Qt 6 doesn’t provide the rcc binary so we create an ad hoc package pulling
  # it from Qt 5.
  rcc = runCommand "rcc" { } ''
    mkdir -p $out/bin
    cp ${lib.getExe' qt5.qtbase.dev "rcc"} $out/bin
  '';
in
stdenv.mkDerivation rec {
  pname = "bitbox";
  version = "4.52.0";

  src = fetchFromGitHub {
    owner = "BitBoxSwiss";
    repo = "bitbox-wallet-app";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-urQjnrBcqTwP+xpcM0L8IpE/Vc+CQiN/2hE5jlBnzdU=";
  };

  postPatch = ''
    substituteInPlace frontends/qt/resources/linux/usr/share/applications/bitbox.desktop \
        --replace-fail 'Exec=BitBox %u' 'Exec=bitbox %u'

    # Link against the Rust library built from source, not the vendored binary.
    substituteInPlace vendor/github.com/breez/breez-sdk-spark-go/breez_sdk_spark/cgo.go \
      --replace-fail "\''${SRCDIR}/lib/linux-amd64" '${lib.getLib breez-sdk-spark}/lib'
    rm vendor/github.com/breez/breez-sdk-spark-go/breez_sdk_spark/lib/linux-amd64/libbreez_sdk_spark_bindings.so
  '';

  dontConfigure = true;

  passthru.web = buildNpmPackage {
    pname = "bitbox-web";
    inherit version;
    inherit src;
    sourceRoot = "${src.name}/frontends/web";
    npmDepsHash = "sha256-G8ZhBG9zdiFvkMVgjLFJcbFFpbqh6+q1xezv9fwwaAg=";
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
    go
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
