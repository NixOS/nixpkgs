{ lib
, stdenv
, fetchFromSourcehut
, fetchpatch
, pkg-config
, meson
, ninja
, cairo
, pango
, wayland
, wayland-protocols
, wayland-scanner
, libxkbcommon
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "wmenu";
  version = "0.1.7";

  strictDeps = true;

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = "wmenu";
    rev = version;
    hash = "sha256-9do7zL7yaZuqVjastySwjsByo5ja+KUP3590VjIyVnI=";
  };

  # Upstream patch needed to fix NULL deref
  patches = [
    (fetchpatch {
      url = "https://git.sr.ht/~adnano/wmenu/commit/2856dddcac861ddf248143e66ba164d7aa05a0bb.patch";
      hash = "sha256-P7SEjMssA8unNAlrgrTHm0uW5pefjpupPb4s/u2fTAM=";
    })
  ];

  nativeBuildInputs = [ pkg-config meson ninja wayland-scanner ];
  buildInputs = [ cairo pango wayland libxkbcommon wayland-protocols scdoc ];

  meta = with lib; {
    description = "An efficient dynamic menu for Sway and wlroots based Wayland compositors";
    homepage = "https://git.sr.ht/~adnano/wmenu";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eken ];
    mainProgram = "wmenu";
  };
}

