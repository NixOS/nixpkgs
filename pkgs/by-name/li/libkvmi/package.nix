{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  glib,
  libuuid,
}:

stdenv.mkDerivation {
  pname = "libkvmi";
  version = "1.1.0-unstable-2023-12-13";

  outputs = [
    "lib"
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "bitdefender";
    repo = "libkvmi";
    rev = "bc80de986bda1b891a1106badf87587bb92dbbb3";
    hash = "sha256-evYRIwguaKgJ8pMhhKKkSc/65GDYnG6DoYRMSkLjowI=";
  };

  buildInputs = [
    glib
    libuuid
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  meta = {
    description = "KVM virtual machine introspection library";
    homepage = "https://github.com/bitdefender/libkvmi";
    license = lib.licenses.lgpl3;
    platforms = lib.lists.intersectLists lib.platforms.linux lib.platforms.x86_64;
    maintainers = [ lib.maintainers.sigmasquadron ];
    mainProgram = "hookguest-libkvmi";
    outputsToInstall = [ "lib" ];
  };
}
