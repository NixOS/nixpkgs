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
  version = "4.67";

  src = fetchFromGitHub {
    owner = "dubeyko";
    repo = "ssdfs-tools";
    rev = "f6410a78b182fc06d3f7894994883455ab63e922";
    hash = "sha256-dbWWVSyX438dZ9Gcxe5crNELPGFpHXGU8EJWy74d5Mw=";
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
