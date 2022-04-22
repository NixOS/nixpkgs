{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, scdoc
, wayland
, wayland-protocols
, libxkbcommon
, cairo
, gdk-pixbuf
, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock-effects";
  version = "1.6-3";

  src = fetchFromGitHub {
    owner = "mortie";
    repo = "swaylock-effects";
    rev = "v${version}";
    sha256 = "sha256-71IX0fC4xCPP6pK63KtvDMb3KoP1rw/Iz3S7BgiLSpg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mortie/swaylock-effects/commit/dfff235b09b475e79d75a040a0307a359974d360.patch";
      sha256 = "t8Xz2wRSBlwGtkpWZyIGWX7V/y0P1r/50P8MfauMh4c=";
    })
  ];

  postPatch = ''
    sed -iE "s/version: '1\.3',/version: '${version}',/" meson.build
  '';

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk-pixbuf pam ];

  mesonFlags = [
    "-Dpam=enabled"
    "-Dgdk-pixbuf=enabled"
    "-Dman-pages=enabled"
  ];

  meta = with lib; {
    description = "Screen locker for Wayland";
    longDescription = ''
      Swaylock, with fancy effects
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnxlxnxx ];
  };
}
