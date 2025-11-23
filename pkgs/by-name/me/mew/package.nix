{
  lib,
  fetchFromGitea,
  stdenv,
  pkg-config,
  pixman,
  wayland,
  wayland-protocols,
  libxkbcommon,
  fcft,
  wayland-scanner,
}:
stdenv.mkDerivation {
  pname = "mew";
  version = "1.0-unstable-2025-06-20";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "sewn";
    repo = "mew";
    rev = "af6440da8fe6683cf0b873e0a98c293bf02c3447";
    hash = "sha256-NbpYITHO81fnaDY0dtolaUBdRqQNKwHQz/lBQMOHM5c=";
  };
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    pixman
    wayland
    wayland-protocols
    libxkbcommon
    fcft
    wayland-scanner
  ];
  makeFlags = [
    # The PREFIX var is hardcoded in the makefile.
    "PREFIX=$(out)"
  ];
  meta = with lib; {
    description = "mew is a efficient dynamic menu for Wayland, an effective port of dmenu to Wayland.";
    homepage = "https://codeberg.org/sewn/mew";
    license = licenses.mit;
    maintainers = with maintainers; [ Notarin ];
    platforms = platforms.linux;
  };
}
