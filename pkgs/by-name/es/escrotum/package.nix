{ lib, python3Packages, fetchFromGitHub
, ffmpeg-full
, gtk3
, pango
, gobject-introspection
, wrapGAppsHook3
}:

with python3Packages; buildPythonApplication {
  pname = "escrotum";
  version = "unstable-2020-12-07";

  src = fetchFromGitHub {
    owner  = "Roger";
    repo   = "escrotum";
    rev    = "a41d0f11bb6af4f08e724b8ccddf8513d905c0d1";
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

  propagatedBuildInputs = [ pygobject3 xcffib pycairo numpy ];

  # Cannot find pango without strictDeps = false
  strictDeps = false;

  outputs = [ "out" "man" ];

  makeWrapperArgs = ["--prefix PATH : ${lib.makeBinPath [ ffmpeg-full ]}"];

  postInstall = ''
    mkdir -p $man/share/man/man1
    cp man/escrotum.1 $man/share/man/man1/
  '';

  meta = with lib; {
    homepage = "https://github.com/Roger/escrotum";
    description = "Linux screen capture using pygtk, inspired by scrot";
    platforms = platforms.linux;
    maintainers = with maintainers; [ rasendubi ];
    license = licenses.gpl3;
    mainProgram = "escrotum";
  };
}
