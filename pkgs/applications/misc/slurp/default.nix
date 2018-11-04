{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, scdoc, cairo
, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  name = "slurp-${version}";
  version = "0dbd03991462397eb92bb40af712c837c898ebf1";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "slurp";
    rev = version;
    sha256 = "0b89ri5h9hg0nqlcrrlyg9zglsgqabn1bs0qd4isdmsq8232davh";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ cairo wayland wayland-protocols ];

  meta = with stdenv.lib; {
    description = "Select a region in a Wayland compositor";
    homepage = https://wayland.emersion.fr/slurp;
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
