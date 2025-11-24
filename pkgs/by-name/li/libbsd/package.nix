{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  libmd,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libbsd";
  version = "0.12.2";

  src = fetchurl {
    url = "https://libbsd.freedesktop.org/releases/${pname}-${version}.tar.xz";
    hash = "sha256-uIzJFj0MZSqvOamZkdl03bocOpcR248bWDivKhRzEBQ=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  enableParallelBuilding = true;

  doCheck = true;

  nativeBuildInputs = [ autoreconfHook ];
  propagatedBuildInputs = [ libmd ];

  patches = [
    # `strtonum(3)` is not available on our default SDK version.
    # https://gitlab.freedesktop.org/libbsd/libbsd/-/issues/30
    ./darwin-enable-strtonum.patch
  ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://gitlab.freedesktop.org/libbsd/libbsd.git";
  };

  # Fix undefined reference errors with version script under LLVM.
  configureFlags = lib.optionals (
    stdenv.cc.bintools.isLLVM && lib.versionAtLeast stdenv.cc.bintools.version "17"
  ) [ "LDFLAGS=-Wl,--undefined-version" ];

  meta = with lib; {
    description = "Common functions found on BSD systems";
    homepage = "https://libbsd.freedesktop.org/";
    license = with licenses; [
      beerware
      bsd2
      bsd3
      bsdOriginal
      isc
      mit
    ];
    platforms = platforms.unix;
    # See architectures defined in src/local-elf.h.
    badPlatforms = lib.platforms.microblaze;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
