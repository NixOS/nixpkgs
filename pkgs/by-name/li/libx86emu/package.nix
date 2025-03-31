{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "libx86emu";
  version = "3.7";

  src = fetchFromGitHub {
    owner = "wfeldt";
    repo = "libx86emu";
    rev = version;
    sha256 = "sha256-ilAmGlkMeuG0FlygMdE3NreFPJJF6g/26C8C5grvjrk=";
  };

  nativeBuildInputs = [ perl ];

  postUnpack = "rm $sourceRoot/git2log";
  patchPhase = ''
    # VERSION is usually generated using Git
    echo "${version}" > VERSION
    substituteInPlace Makefile --replace "/usr" "/"
  '';

  buildFlags = [
    "shared"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  enableParallelBuilding = true;

  installFlags = [
    "DESTDIR=$(out)"
    "LIBDIR=/lib"
  ];

  meta = with lib; {
    description = "x86 emulation library";
    license = licenses.bsd2;
    homepage = "https://github.com/wfeldt/libx86emu";
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.linux;
  };
}
