{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  python3,
  tre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsystre";
  version = "1.0.2";

  # MSYS2 carries libsystre as a small, standalone wrapper source bundle.
  # Reference: fix-nixpkgs/MINGW-packages/mingw-w64-libsystre
  src = ./src;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    tre
  ];

  # libsystre's installed regex.h includes <tre/tre.h>, so consumers need tre headers.
  propagatedBuildInputs = [
    tre.dev
  ];

  postPatch = ''
    patchShebangs meson_post_install.py
  '';

  meta = {
    description = "Wrapper around TRE that provides a POSIX regex API (libgnurx/libregex replacement)";
    homepage = "https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-libsystre";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.windows;
  };
})


