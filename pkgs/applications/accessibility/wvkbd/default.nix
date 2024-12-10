{
  stdenv,
  lib,
  fetchFromGitHub,
  wayland-scanner,
  wayland,
  pango,
  glib,
  harfbuzz,
  cairo,
  pkg-config,
  libxkbcommon,
}:

stdenv.mkDerivation rec {
  pname = "wvkbd";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "jjsullivan5196";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9gDxMH1hghqjcXlbda7CHjDdjcjApjjie7caihKIg9M=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    cairo
    glib
    harfbuzz
    libxkbcommon
    pango
    wayland
  ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/jjsullivan5196/wvkbd";
    description = "On-screen keyboard for wlroots";
    maintainers = [ maintainers.elohmeier ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    mainProgram = "wvkbd-mobintl";
  };
}
