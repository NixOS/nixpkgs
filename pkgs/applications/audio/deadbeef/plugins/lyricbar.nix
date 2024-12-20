{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  deadbeef,
  gtkmm3,
  libxmlxx3,
}:

stdenv.mkDerivation {
  pname = "deadbeef-lyricbar-plugin";
  version = "unstable-2019-01-29";

  src = fetchFromGitHub {
    owner = "C0rn3j";
    repo = "deadbeef-lyricbar";
    rev = "8f99b92ef827c451c43fc7dff38ae4f15c355e8e";
    sha256 = "108hx5530f4xm8p9m2bk79nq7jkhcj39ad3vmxb2y6h6l2zv5kwl";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    deadbeef
    gtkmm3
    libxmlxx3
  ];

  buildFlags = [ "gtk3" ];

  meta = with lib; {
    description = "Plugin for DeaDBeeF audio player that fetches and shows the song’s lyrics";
    homepage = "https://github.com/C0rn3j/deadbeef-lyricbar";
    license = licenses.mit;
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
  };
}
