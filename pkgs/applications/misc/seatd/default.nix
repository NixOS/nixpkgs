{ fetchFromSourcehut
, lib
, meson
, ninja
, pkg-config
, scdoc
, stdenv
, systemd
}:

stdenv.mkDerivation rec {
  pname = "seatd";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "seatd";
    rev = version;
    sha256 = "sha256-JwlJLHkRgSRqfQEhXbzuFTmhxfbwKVdLICPbTDbC9M0=";
  };

  outputs = [ "bin" "out" "dev" "man" ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [ meson ninja pkg-config scdoc ];

  buildInputs = [ systemd ];

  mesonFlags = [ "-Dlogind=enabled" "-Dbuiltin=enabled" ];

  meta = with lib; {
    description = "A universal seat management library";
    changelog   = "https://git.sr.ht/~kennylevinsen/seatd/refs/${version}";
    homepage    = "https://sr.ht/~kennylevinsen/seatd/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ emantor ];
  };
}
