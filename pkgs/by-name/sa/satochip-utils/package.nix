{
  lib,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  makeBinaryWrapper,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "satochip-utils";
  version = "0.4.0-beta";
  format = "other";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Toporin";
    repo = "Satochip-Utils";
    tag = "v${version}";
    hash = "sha256-QOnW06sfSPN7tgsAfJYySpY4/+53x1hmxFJK/9s9Jhc=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cbor2
    customtkinter
    mnemonic
    pillow
    pycryptotools
    pyperclip
    pyqrcode
    pysatochip
    pyscard
    tkinter
  ];

  installPhase = ''
    runHook preInstall

    install -d $out/lib/satochip-utils
    cp -r . $out/lib/satochip-utils/

    makeBinaryWrapper ${python3.interpreter} $out/bin/satochip-utils \
      --set PYTHONPATH "$PYTHONPATH:$out/lib/satochip-utils" \
      --add-flags "$out/lib/satochip-utils/satochip_utils.py"

    install -Dm644 satochip_utils.png $out/share/icons/hicolor/128x128/apps/satochip-utils.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = pname;
      desktopName = "Satochip Utils";
      comment = "Configure your Satochip, Satodime or Seedkeeper hardware wallet card";
      categories = [
        "Finance"
        "Security"
        "Utility"
      ];
    })
  ];

  doCheck = false;

  meta = {
    description = "GUI tool to configure Satochip, Satodime and Seedkeeper hardware wallet cards";
    homepage = "https://satochip.io/satochip-utils/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ stargate01 ];
    mainProgram = "satochip-utils";
  };
}
