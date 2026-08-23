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
    sha256 = "02c536mc17ccsrzgma366k3wlm02ivklvr30fafxl981zgghlii4";
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
