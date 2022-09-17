{ stdenv
, lib
, fetchFromGitHub
, wayland-scanner
, wayland
, pango
, glib
, harfbuzz
, cairo
, pkg-config
, libxkbcommon
}:

stdenv.mkDerivation rec {
  pname = "wvkbd";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "jjsullivan5196";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-h/hXHQfLiDkVKYZFsjyq2+w1Pnn3lR6H+r+fXYkP5ZY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ wayland-scanner wayland pango glib harfbuzz cairo libxkbcommon ];
  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/jjsullivan5196/wvkbd";
    description = "On-screen keyboard for wlroots";
    maintainers = [ maintainers.elohmeier ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
