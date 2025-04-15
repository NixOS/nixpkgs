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
  version = "4.53";

  src = fetchFromGitHub {
    owner = "dubeyko";
    repo = "ssdfs-tools";
    rev = "5cf623d11b41f2581923494142dcd5277af39093";
    hash = "sha256-Mud9KAd2nGY4A8l8EhJvmrK93oV2wO5RCsQIjmEAaeg=";
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

  meta = with lib; {
    description = "SSDFS file system utilities";
    homepage = "https://github.com/dubeyko/ssdfs-tools";
    license = licenses.bsd3Clear;
    maintainers = with maintainers; [ ners ];
    platforms = platforms.linux;
  };
}
