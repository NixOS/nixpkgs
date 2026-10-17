{
  lib,
  stdenv,
  fetchFromGitHub,
  icon-slicer,
  xcursorgen,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "openzone-cursors";
  version = "1.2.9";

  src = fetchFromGitHub {
    owner = "ducakar";
    repo = "openzone-cursors";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JEYK3/sBJdqdcmDkTeeOAlTKxzRmqPp+1oydwKoZhQk=";
  };

  nativeBuildInputs = [
    icon-slicer
    xcursorgen
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = {
    description = "Clean and sharp X11/Wayland cursor theme";
    homepage = "https://www.gnome-look.org/p/999999/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zaninime ];
    platforms = lib.platforms.linux;
  };
})
