{
  lib,
  fetchFromGitHub,
  pkgs,
  python3,
  wrapGAppsHook3,
  gobject-introspection,
}:

python3.pkgs.buildPythonApplication {
  pname = "pdf-quench";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "linuxerwang";
    repo = "pdf-quench";
    rev = "b72b3970b371026f9a7ebe6003581e8a63af98f6";
    sha256 = "1rp9rlwr6rarcsxygv5x2c5psgwl6r69k0lsgribgyyla9cf2m7n";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];
  buildInputs = with pkgs; [
    gtk3
    goocanvas2
    poppler_gi
  ];
  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pypdf2
  ];

  format = "other";
  doCheck = false;

  installPhase = ''
    install -D -T -m 755 src/pdf_quench.py $out/bin/pdf-quench
  '';

  meta = with lib; {
    homepage = "https://github.com/linuxerwang/pdf-quench";
    description = "A visual tool for cropping pdf files";
    mainProgram = "pdf-quench";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ flokli ];
  };
}
