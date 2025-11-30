{
  lib,
  stdenv,
  fetchhg,
  qt5,
}:

let
  inherit (qt5) qtbase qtmultimedia wrapQtAppsHook;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rpcemu";
  version = "0.9.5";

  src = fetchhg {
    url = "http://www.home.marutan.net/hg/rpcemu";
    rev = "release_${finalAttrs.version}";
    sha256 = "sha256-raZ+u8CnX33CsOSI20utegwPVVk8bcZqDNJ/5UcMP9w=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
  ];

  configurePhase = ''
    runHook preConfigure

    cd src/qt5
    qmake

    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall

    cd ../..
    install -Dm755 rpcemu-interpreter -t $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.marutan.net/rpcemu/index.php";
    description = "Risc PC Emulator";
    mainProgram = "rpcemu-interpreter";
    longDescription = ''
      RPCEmu is an emulator of classic Acorn computer systems, such as the Risc
      PC and A7000. It runs on multiple platforms including Windows, Linux and
      Mac OS X.

      RPCEmu should be considered Alpha Quality code. It has many known and
      unknown bugs, and all files used with it should be well backed up before
      using them with RPCEmu.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
