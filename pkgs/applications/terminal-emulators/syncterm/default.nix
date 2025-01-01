{ lib, stdenv, fetchurl, fetchpatch, pkg-config, perl, unzip, autoPatchelfHook, ncurses, SDL2, alsa-lib }:

stdenv.mkDerivation rec {
  pname = "syncterm";
  version = "1.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}-src.tgz";
    sha256 = "19m76bisipp1h3bc8mbq83b851rx3lbysxb0azpbr5nbqr2f8xyi";
  };

  patches = [
    # Cherry-picks from the upstream Synchronet tree, removing calls to `pthread_yield`.
    # See upstream issue: https://gitlab.synchro.net/main/sbbs/-/issues/299
    (fetchpatch {
        url = "https://gitlab.synchro.net/main/sbbs/-/commit/851627df99f48d8eaad33d3a98ef309b4371f359.patch";
        hash = "sha256-DbFAeJnrwFyfEpZgZFN8etqX6vQ3ca2TJwaqp0aHeo4=";
    })
    ./0001-use-sched-yield-53264f2b.patch
  ];
  # We can't use sourceRoot, as the cherry-picked patches apply to files outside of it.
  postPatch = ''cd src/syncterm'';

  CFLAGS = [
    "-DHAS_INTTYPES_H"
    "-DXPDEV_DONT_DEFINE_INTTYPES"

    "-Wno-unused-result"
    "-Wformat-overflow=0"
  ] ++ (lib.optionals stdenv.hostPlatform.isLinux [
    "-DUSE_ALSA_SOUND" # Don't use OSS for beeps.
  ]);
  makeFlags = [
    "PREFIX=$(out)"
    "RELEASE=1"
    "USE_SDL_AUDIO=1"
  ];

  nativeBuildInputs = [ autoPatchelfHook pkg-config SDL2 perl unzip ]; # SDL2 for `sdl2-config`.
  buildInputs = [ ncurses SDL2 ]
    ++ (lib.optional stdenv.hostPlatform.isLinux alsa-lib);
  runtimeDependencies = [ ncurses SDL2 ]; # Both of these are dlopen()'ed at runtime.

  meta = with lib; {
    # error: unsupported option '-fsanitize=safe-stack' for target 'x86_64-apple-darwin'
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) || stdenv.hostPlatform.isDarwin;
    homepage = "https://syncterm.bbsdev.net/";
    description = "BBS terminal emulator";
    mainProgram = "syncterm";
    maintainers = with maintainers; [ embr ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
