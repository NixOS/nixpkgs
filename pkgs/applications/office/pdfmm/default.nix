{ bash
, coreutils
, fetchFromGitHub
, ghostscript
, glibc
, gnome
, gnused
, lib
, resholve
, xorg
}:

resholve.mkDerivation rec {
  pname = "pdfmm";
  version = "unstable-2019-01-24";

  src = fetchFromGitHub {
    owner = "jpfleury";
    repo = pname;
    rev = "45ee7796659d23bb030bf06647f1af85e1d2b52d";
    hash = "sha256-TOISD/2g7MwnLrtpMnfr2Ln0IiwlJVNavWl4eh/uwN0=";
  };

  dontBuild = true;

  installPhase = ''
    install -Dm 0755 pdfmm $out/bin/pdfmm
  '';

  solutions.default = {
    scripts = [
      "bin/pdfmm"
    ];
    interpreter = "${bash}/bin/bash";
    inputs = [
      coreutils
      ghostscript
      glibc
      gnome.zenity
      gnused
      xorg.xmessage
    ];
    execer = [
      "cannot:${glibc.bin}/bin/locale"
      "cannot:${gnome.zenity}/bin/zenity"
      "cannot:${xorg.xmessage}/bin/xmessage"
    ];
    keep."$toutLu" = true;
  };

  meta = with lib; {
    description = "Graphical assistant to reduce the size of a PDF file";
    homepage = "https://github.com/jpfleury/pdfmm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
  };
}
