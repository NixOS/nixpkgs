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
  version = "4.75";

  src = fetchFromGitHub {
    owner = "dubeyko";
    repo = "ssdfs-tools";
    rev = "08cf4fbb399f4eb35646964ea9d56b23314f4701";
    hash = "sha256-MPF87W5nuM2miXM97F49sTAZBTtFcDaqYKqPZlLLr9s=";
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
