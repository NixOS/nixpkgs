{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  wrapQtAppsHook,
  hidapi,
  readline,
  qtsvg,
  qtxmlpatterns,
}:

stdenv.mkDerivation {
  pname = "flirc";
  version = "3.27.10";

  src = fetchurl {
    url = "https://web.archive.org/web/20240110170238/http://apt.flirc.tv/arch/x86_64/flirc.latest.x86_64.tar.gz";
    hash = "sha256-iTr4vzFQ/+dsbsYD6sc8aTHctTkLKf5HnHBnO7cX5qc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    wrapQtAppsHook
  ];

  buildInputs = [
    hidapi
    readline
    qtsvg
    qtxmlpatterns
  ];

  dontConfigure = true;
  dontBuild = true;

  # udev rules don't appear in the official package
  # https://flirc.gitbooks.io/flirc-instructions/content/linux.html
  installPhase = ''
    install -D -t $out/bin/ Flirc flirc_util
    install -D ${./99-flirc.rules} $out/lib/udev/rules.d/99-flirc.rules
  '';

  meta = with lib; {
    homepage = "https://flirc.tv/more/flirc-usb";
    description = "Use any Remote with your Media Center";
    maintainers = with maintainers; [ aanderse ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
