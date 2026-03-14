{
  lib,
  stdenv,
  fetchgit,
  groff,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mktemp";
  version = "unstable-2025-06-12";

  # Have `configure' avoid `/usr/bin/nroff' in non-chroot builds.
  env.NROFF = "${groff}/bin/nroff";

  src = fetchgit {
    url = "https://git.mktemp.org/mktemp.git";
    rev = "315362892afbdfdde0b20780fee7e5aabe2c4ef8";
    hash = "sha256-GeFCqU+YXeQHi4Nt0o/ooKlddDhRbgyk1hICL/cdHjw=";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Simple tool to make temporary file handling in shells scripts safe and simple";
    mainProgram = "mktemp";
    homepage = "https://www.mktemp.org";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ armeenm ];
    platforms = lib.platforms.unix;
  };
})
