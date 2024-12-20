{
  lib,
  stdenv,
  fetchFromSourcehut,
  fetchpatch,
  wayland,
  pixman,
  pkg-config,
  wayland-scanner,
}:

stdenv.mkDerivation rec {
  pname = "river-tag-overlay";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hLyXdLi/ldvwPJ1oQQsH5wgflQJuXu6vhYw/qdKAV9E=";
  };

  patches = [
    # Backport cross fix.
    (fetchpatch {
      url = "https://git.sr.ht/~leon_plickat/river-tag-overlay/commit/791eaadf46482121a4c811ffba13d03168d74d8f.patch";
      sha256 = "CxSDcweHGup1EF3oD/2vhP6RFoeYorj0BwmlgA3tbPE=";
    })
  ];

  buildInputs = [
    pixman
    wayland
  ];
  nativeBuildInputs = [
    pkg-config
    wayland-scanner
  ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = with lib; {
    description = "Pop-up showing tag status";
    homepage = "https://sr.ht/~leon_plickat/river-tag-overlay";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ edrex ];
    platforms = platforms.linux;
    mainProgram = "river-tag-overlay";
  };
}
