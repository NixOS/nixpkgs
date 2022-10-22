{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, ninja
, meson
, scdoc
, wayland-protocols
, freetype
, harfbuzz
, cairo
, pango
, wayland
, libxkbcommon
}:

stdenv.mkDerivation rec {
  pname = "tofi";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "philj56";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wF9gj1VNu+ik/dq5Q0l6rNfqU9kQXyLiAQvbU1OoHdg=";
  };

  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-protocols ];
  buildInputs = [ freetype harfbuzz cairo pango wayland libxkbcommon ];

  meta = with lib; {
    description = "Tiny dynamic menu for Wayland";
    homepage = "https://github.com/philj56/tofi";
    license = licenses.mit;
    maintainers = with maintainers; [ fbergroth ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
