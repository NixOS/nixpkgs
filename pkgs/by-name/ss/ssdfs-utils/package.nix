{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  libuuid,
  zlib,
}:

stdenv.mkDerivation {
  # The files and commit messages in the repository refer to the package
  # as ssdfs-utils, not ssdfs-tools.
  pname = "ssdfs-utils";
  # The version is taken from `configure.ac`, there are no tags.
  version = "4.70";

  src = fetchFromGitHub {
    owner = "dubeyko";
    repo = "ssdfs-tools";
    rev = "3f640111ba5cbdd1ee6ff73f6b73133994d271e3";
    hash = "sha256-UvssPXvNUP9PJSQU4BYddpbee+rHHZdRbriIaUq71i0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    libtool
    libuuid
    zlib
  ];

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "SSDFS file system utilities";
    homepage = "https://github.com/dubeyko/ssdfs-tools";
    license = lib.licenses.bsd3Clear;
    maintainers = with lib.maintainers; [ ners ];
    platforms = lib.platforms.linux;
  };
}
