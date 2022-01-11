{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, wayland
, cairo
, pango
, gtk
, pkg-config
, scdoc
, libnotify
, glib
, wrapGAppsHook
, hicolor-icon-theme
}:

stdenv.mkDerivation rec {
  pname = "swappy";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jtheoof";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sINX7pJ0msis7diGFTCgD4Mamd3yGGJew1uD8de4VOg=";
  };

  nativeBuildInputs = [ glib meson ninja pkg-config scdoc wrapGAppsHook ];

  buildInputs = [
    cairo pango gtk libnotify wayland glib hicolor-icon-theme
  ];

  strictDeps = true;

  mesonFlags = [
    # TODO: https://github.com/NixOS/nixpkgs/issues/36468
    "-Dc_args=-I${glib.dev}/include/gio-unix-2.0"
  ];

  meta = with lib; {
    homepage = "https://github.com/jtheoof/swappy";
    description = "A Wayland native snapshot editing tool, inspired by Snappy on macOS";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux;
  };
}
