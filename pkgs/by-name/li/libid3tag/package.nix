{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  gperf,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libid3tag";
  version = "0.16.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "tenacityteam";
    repo = "libid3tag";
    rev = version;
    hash = "sha256-6/49rk7pmIpJRj32WmxC171NtdIOaMNhX8RD7o6Jbzs=";
  };

  postPatch = ''
    substituteInPlace packaging/id3tag.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  outputs = [
    "out"
    "dev"
  ];

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
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
}
