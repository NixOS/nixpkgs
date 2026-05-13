{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  gperf,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libid3tag";
  version = "0.16.4";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromCodeberg {
    owner = "tenacityteam";
    repo = "libid3tag";
    rev = finalAttrs.version;
    hash = "sha256-v3tvZmQE6G8Xsk+eluVtlou0Nyhyaisv0UclivQBi28=";
  };

  postPatch = ''
    substituteInPlace packaging/id3tag.pc.in \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "@CMAKE_INSTALL_FULL_LIBDIR@"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gperf
  ];

  buildInputs = [
    zlib
  ];

  meta = {
    description = "ID3 tag manipulation library";
    homepage = "https://codeberg.org/tenacityteam/libid3tag";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
