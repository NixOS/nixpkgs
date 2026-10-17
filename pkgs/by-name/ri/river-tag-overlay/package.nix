{
  lib,
  stdenv,
  fetchFromSourcehut,
  fetchpatch,
  fetchpatch2,
  wayland,
  pixman,
  pkg-config,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "river-tag-overlay";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = "river-tag-overlay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hLyXdLi/ldvwPJ1oQQsH5wgflQJuXu6vhYw/qdKAV9E=";
  };

  patches = [
    # Backport cross fix.
    (fetchpatch {
      url = "https://git.sr.ht/~leon_plickat/river-tag-overlay/commit/791eaadf46482121a4c811ffba13d03168d74d8f.patch";
      sha256 = "CxSDcweHGup1EF3oD/2vhP6RFoeYorj0BwmlgA3tbPE=";
    })
    # Specify argument types for C23 compatibility (gcc 15).
    (fetchpatch2 {
      url = "https://git.sr.ht/~leon_plickat/river-tag-overlay/commit/b7d9232f9106c6d2c3ecce802495f14069ce3406.patch";
      hash = "sha256-/fNpVPY09zwwymS/VNaonqX7jtdflC3Iot5R26VsTTw=";
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

  meta = {
    description = "Pop-up showing tag status";
    homepage = "https://sr.ht/~leon_plickat/river-tag-overlay";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ edrex ];
    platforms = lib.platforms.linux;
    mainProgram = "river-tag-overlay";
  };
})
