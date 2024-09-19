{ lib
, stdenv
, fetchurl
, autoreconfHook
, gdbm
, gmp
, libffi
, pkg-config
, readline
, texinfo
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librep";
  version = "0.92.7";

  src = fetchurl {
    url = "https://download.tuxfamily.org/librep/librep_${finalAttrs.version}.tar.xz";
    hash = "sha256-SKGWeax8BTCollfeGP/knFdZpf9w/IRJKLDl0AOVrK4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
  ];

  buildInputs = [
    gdbm
    gmp
    libffi
    readline
  ];

  strictDeps = true;

  # ensure libsystem/ctype functions don't get duplicated when using clang
  configureFlags = lib.optionals stdenv.isDarwin [ "CFLAGS=-std=gnu89" ];

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://sawfish.tuxfamily.org/";
    description = "Fast, lightweight, and versatile Lisp environment";
    longDescription = ''
      librep is a Lisp system for UNIX, comprising an interpreter, a byte-code
      compiler, and a virtual machine. It can serve as an application extension
      language but is also suitable for standalone scripts.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
# TODO: investigate fetchFromGithub
