{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  version = "1.1.5";
  pname = "nanomsg";

  src = fetchFromGitHub {
    owner = "nanomsg";
    repo = "nanomsg";
    rev = version;
    sha256 = "01ddfzjlkf2dgijrmm3j3j8irccsnbgfvjcnwslsfaxnrmrq5s64";
  };

  patches = [
    # Add pkgconfig fix from https://github.com/nanomsg/nanomsg/pull/1085
    (fetchpatch {
      url = "https://github.com/nanomsg/nanomsg/commit/e3323f19579529d272cb1d55bd6b653c4f34c064.patch";
      hash = "sha256-URz7TAqqpKxqjgvQqNX4WNSShwiEzAvO2h0hCZ2NhVY=";
    })
    # Fix compatibility with Cmake 4.0 and up
    (fetchpatch {
      url = "https://github.com/nanomsg/nanomsg/commit/eb24489839de3e2419360c67cc38842f223836d9.patch";
      hash = "sha256-yaQWWZLW4YbiI41oV0nj7zap3lEs0Gwwb9kTD6o3La8=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  # https://github.com/nanomsg/nanomsg/issues/1082
  postPatch = ''
    substituteInPlace src/pkgconfig.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = with lib; {
    description = "Socket library that provides several common communication patterns";
    homepage = "https://nanomsg.org/";
    license = licenses.mit;
    mainProgram = "nanocat";
    platforms = platforms.unix;
  };
}
