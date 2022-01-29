{ lib, stdenv, fetchurl, pkg-config, perl, unzip, autoPatchelfHook, ncurses, SDL2, alsa-lib }:

stdenv.mkDerivation rec {
  pname = "syncterm";
  version = "1.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}-src.tgz";
    sha256 = "19m76bisipp1h3bc8mbq83b851rx3lbysxb0azpbr5nbqr2f8xyi";
  };
  sourceRoot = "${pname}-${version}/src/syncterm";

  CFLAGS = [
    "-DHAS_INTTYPES_H"
    "-DXPDEV_DONT_DEFINE_INTTYPES"

    "-Wno-unused-result"
    "-Wformat-overflow=0"
  ] ++ (lib.optionals stdenv.isLinux [
    "-DUSE_ALSA_SOUND" # Don't use OSS for beeps.
  ]);
  makeFlags = [
    "PREFIX=$(out)"
    "RELEASE=1"
    "USE_SDL_AUDIO=1"
  ];

  nativeBuildInputs = [ autoPatchelfHook pkg-config SDL2 perl unzip ]; # SDL2 for `sdl2-config`.
  buildInputs = [ ncurses SDL2 ]
    ++ (lib.optional stdenv.isLinux alsa-lib);
  runtimeDependencies = [ ncurses SDL2 ]; # Both of these are dlopen()'ed at runtime.

  meta = with lib; {
    homepage = "https://syncterm.bbsdev.net/";
    description = "BBS terminal emulator";
    maintainers = with maintainers; [ embr ];
    license = licenses.gpl2Plus;
  };
}
