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

resholve.mkDerivation (finalAttrs: {
  pname = "pdfmm";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "jpfleury";
    repo = "pdfmm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DX/czFumKN8flrYMf1wXZRFj09rDBJtzQkHZSglghUY=";
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

  meta = {
    description = "Graphical assistant to reduce the size of a PDF file";
    homepage = "https://github.com/jpfleury/pdfmm";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "pdfmm";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
