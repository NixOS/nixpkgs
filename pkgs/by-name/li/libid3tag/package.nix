{
  lib,
  stdenv,
  fetchFromGitea,
  fetchpatch,
  cmake,
  gperf,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libid3tag";
  version = "0.16.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "tenacityteam";
    repo = "libid3tag";
    rev = version;
    hash = "sha256-6/49rk7pmIpJRj32WmxC171NtdIOaMNhX8RD7o6Jbzs=";
  };

  patches = [
    # Fix the build with CMake 4.
    (fetchpatch {
      name = "libid3tag-fix-cmake-4.patch";
      url = "https://codeberg.org/tenacityteam/libid3tag/commit/eee94b22508a066f7b9bc1ae05d2d85982e73959.patch";
      hash = "sha256-OAdMapNr8qpvXZqNOZ3LUHQ1H79zD1rvzrVksqmz6dU=";
    })
  ];

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
}
