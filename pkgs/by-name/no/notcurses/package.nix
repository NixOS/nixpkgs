{ lib
, stdenv
, fetchFromGitHub
, cmake
, libdeflate
, libunistring
, ncurses
, pandoc
, pkg-config
, zlib
, multimediaSupport ? true, ffmpeg
, qrcodegenSupport ? true, qrcodegen
}:

stdenv.mkDerivation rec {
  pname = "notcurses";
  version = "3.0.9";

  src = fetchFromGitHub {
    owner = "dankamongmen";
    repo = "notcurses";
    rev = "v${version}";
    sha256 = "sha256-8SJeqLcV4xp968YgGsJccsgpB5wwaJDaoWsaYxf8upM=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    pandoc
    pkg-config
  ];

  buildInputs = [
    libdeflate
    libunistring
    ncurses
    zlib
  ]
  ++ lib.optional qrcodegenSupport qrcodegen
  ++ lib.optional multimediaSupport ffmpeg;

  cmakeFlags =
    lib.optional (qrcodegenSupport) "-DUSE_QRCODEGEN=ON"
    ++ lib.optional (!multimediaSupport) "-DUSE_MULTIMEDIA=none";

  # https://github.com/dankamongmen/notcurses/issues/2661
  postPatch = ''
    substituteInPlace tools/notcurses-core.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace tools/notcurses-ffi.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace tools/notcurses++.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    substituteInPlace tools/notcurses.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    homepage = "https://github.com/dankamongmen/notcurses";
    description = "Blingful TUIs and character graphics";
    longDescription = ''
      Notcurses is a library facilitating complex TUIs on modern terminal
      emulators, supporting vivid colors, multimedia, and Unicode to the maximum
      degree possible. Things can be done with Notcurses that simply can't be
      done with NCURSES.

      It is not a source-compatible X/Open Curses implementation, nor a
      replacement for NCURSES on existing systems.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ AndersonTorres ];
    inherit (ncurses.meta) platforms;
  };
}
