{
  lib,
  flutter327,
  fetchFromGitHub,
  gtk3,
  zenity,
}:

flutter327.buildFlutterApplication rec {
  pname = "chameleonultragui";
  version = "1.1.1";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  src = fetchFromGitHub {
    owner = "GameTec-live";
    repo = "ChameleonUltraGUI";
    rev = "e35a13abd8af1854019cf8ebb6aa8e3a6b8eaaf7";
    sha256 = "sha256-Be/mZyKSWrgWJQUVZ73BVUAp2s73AsEqnvXCcT8IQmw=";
  };

  gitHashes = {
    file_saver = "sha256-kZ8qAkK4SS5yoTJItT/3QMDmk10gkH1k+9hZyM9T1EM=";
    flutter_libserialport = "sha256-/RQV3MGwFkmXD0k25rFaROT0F1+oHT5+gCBnd3l9S1w=";
    usb_serial = "sha256-QjcTh3RcPUS1pyNbA6Mj2TeHbDCMNKYaN4vVtLhIYCs=";
  };

  sourceRoot = "${src.name}/chameleonultragui";

  buildInputs = [
    gtk3
    zenity
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    flutter test

    runHook postCheck
  '';

  postInstall = ''
    install -Dm0644 aur/chameleonultragui.desktop $out/share/applications/chameleonultragui.desktop
    install -Dm0644 aur/chameleonultragui.png $out/share/pixmaps/chameleonultragui.png
  '';

  meta = {
    description = "GUI for the Chameleon Ultra/Chameleon Lite written in Flutter";
    homepage = "https://github.com/GameTec-live/ChameleonUltraGUI";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [
      lib.maintainers.briaoeuidhtns
    ];
  };
}
