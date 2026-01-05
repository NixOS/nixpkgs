{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  ffmpeg-full,
  gtk3,
  pango,
  gobject-introspection,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication {
  pname = "escrotum";
  version = "1.0.1-unstable-2020-12-07";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Roger";
    repo = "escrotum";
    rev = "a41d0f11bb6af4f08e724b8ccddf8513d905c0d1";
    sha256 = "sha256-z0AyTbOEE60j/883X17mxgoaVlryNtn0dfEB0C18G2s=";
  };

  buildInputs = [
    gtk3
    pango
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pygobject3
    xcffib
    pycairo
    numpy
  ];

  # Cannot find pango without strictDeps = false
  strictDeps = false;

  outputs = [
    "out"
    "man"
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg-full ]}" ];

  postInstall = ''
    mkdir -p $man/share/man/man1
    cp man/escrotum.1 $man/share/man/man1/
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    homepage = "https://github.com/Roger/escrotum";
    description = "Linux screen capture using pygtk, inspired by scrot";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.gpl3;
    mainProgram = "escrotum";
  };
}
