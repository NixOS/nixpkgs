{ lib, stdenv, fetchFromSourcehut, nixos, wayland, pixman, pkg-config }:

stdenv.mkDerivation rec {
  pname = "river-tag-overlay";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hLyXdLi/ldvwPJ1oQQsH5wgflQJuXu6vhYw/qdKAV9E=";
  };

  buildInputs = [ pixman wayland ];
  nativeBuildInputs = [ pkg-config ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = with lib; {
    description = "A pop-up showing tag status";
    homepage = "https://sr.ht/~leon_plickat/river-tag-overlay";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ edrex ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
