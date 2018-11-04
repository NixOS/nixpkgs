{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, scdoc, cairo, libjpeg
, wayland, wayland-protocols }:

stdenv.mkDerivation rec {
  name = "grim-${version}";
  version = "61df6f0a9531520c898718874c460826bc7e2b42";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = "grim";
    rev = version;
    sha256 = "1n1fd3ash88fp33vyjndwdf77ig6mnws9jxhgjy5ag07l4xv8923";
  };

  nativeBuildInputs = [ meson ninja pkgconfig scdoc ];
  buildInputs = [ cairo wayland wayland-protocols libjpeg ];

  meta = with stdenv.lib; {
    description = "Grab images from a Wayland compositor";
    homepage = https://wayland.emersion.fr/grim;
    license = licenses.mit;
    maintainers = with maintainers; [ koral ];
    platforms = platforms.linux;
  };
}
