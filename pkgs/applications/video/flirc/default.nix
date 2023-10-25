{ lib
, mkDerivation
, fetchurl
, autoPatchelfHook
, hidapi
, readline
, qtsvg
, qtxmlpatterns
}:

mkDerivation rec {
  pname = "flirc";
  version = "3.24.3";

  src = fetchurl {
    url = "https://web.archive.org/web/20211021211803/http://apt.flirc.tv/arch/x86_64/flirc.latest.x86_64.tar.gz";
    sha256 = "0p4pp7j70lbw6m25lmjg6ibc67r6jcy7qs3kki9f86ji1jvrxpga";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
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
