{
  bash,
  coreutils,
  fetchFromGitHub,
  ghostscript,
  locale,
  zenity,
  gnused,
  lib,
  resholve,
}:

resholve.mkDerivation {
  pname = "pdfmm";
  version = "unstable-2019-01-24";

  src = fetchFromGitHub {
    owner = "jpfleury";
    repo = "pdfmm";
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
      locale
      zenity
      gnused
    ];
    fake = {
      # only need xmessage if zenity is unavailable
      external = [ "xmessage" ];
    };
    execer = [
      "cannot:${zenity}/bin/zenity"
    ];
    keep."$toutLu" = true;
  };

<<<<<<< HEAD
  meta = {
    description = "Graphical assistant to reduce the size of a PDF file";
    homepage = "https://github.com/jpfleury/pdfmm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ urandom ];
    mainProgram = "pdfmm";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
=======
  meta = with lib; {
    description = "Graphical assistant to reduce the size of a PDF file";
    homepage = "https://github.com/jpfleury/pdfmm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ urandom ];
    mainProgram = "pdfmm";
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
