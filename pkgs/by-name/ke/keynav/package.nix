{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libx11,
  xorgproto,
  libxtst,
  libxi,
  libxext,
  libxinerama,
  libxrandr,
  glib,
  cairo,
  xdotool,
}:

let
  release = "20220825";
in
stdenv.mkDerivation {
  pname = "keynav";
  version = "0.${release}.0";

  src = fetchFromGitHub {
    owner = "jordansissel";
    repo = "keynav";
    rev = "28a1ba9a045c62a9d2bc5c3474a66d96c8bf5c32";
    hash = "sha256-y4ONq6fDBFhVGASvz28zlJRXfkCE/j8GDcbq/j8xvUY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    xorgproto
    libxtst
    libxi
    libxext
    libxinerama
    libxrandr
    glib
    cairo
    xdotool
  ];

  postPatch = ''
    echo >>VERSION MAJOR=0
    echo >>VERSION RELEASE=${release}
    echo >>VERSION REVISION=0
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/keynav/doc
    cp keynav $out/bin
    cp keynavrc $out/share/keynav/doc
  '';

  meta = {
    description = "Generate X11 mouse clicks from keyboard";
    homepage = "https://www.semicomplete.com/projects/keynav/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
    mainProgram = "keynav";
  };
}
