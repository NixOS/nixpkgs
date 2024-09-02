{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  scdoc,
  wayland,
  wayland-protocols,
  wayland-scanner,
  libxkbcommon,
  cairo,
  gdk-pixbuf,
  pam,
}:

stdenv.mkDerivation rec {
  pname = "swaylock-effects";
  version = "1.7.0.0";

  src = fetchFromGitHub {
    owner = "jirutka";
    repo = "swaylock-effects";
    rev = "v${version}";
    sha256 = "sha256-cuFM+cbUmGfI1EZu7zOsQUj4rA4Uc4nUXcvIfttf9zE=";
  };

  postPatch = ''
    sed -iE "s/version: '1\.3',/version: '${version}',/" meson.build
  '';

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    cairo
    gdk-pixbuf
    pam
  ];

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
    mainProgram = "swaylock";
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ gnxlxnxx ];
  };
}
