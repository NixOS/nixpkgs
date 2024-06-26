{ lib
, stdenv
, fetchFromGitHub
, meson
, pkg-config
, ninja
, zlib
, libpng
, libjpeg
, curl
, SDL2
, openal
, openalSoft
, libogg
, libvorbis
, libXi
, wayland
, wayland-protocols
, libdecor
, ffmpeg
, x11Support ? stdenv.isLinux
, waylandSupport ? stdenv.isLinux
}:

stdenv.mkDerivation rec {
  pname = "q2pro";
  version = "0-unstable-2023-12-16";

  src = fetchFromGitHub {
    owner = "skullernet";
    repo = pname;
    rev = "d7e4d98b51a69e4bc0f9394626d7227e59c4c628";
    hash = "sha256-2xxdpz4PrOk1YjdrNY98Ypsektvl2v5zINWZA7XYo3g=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  buildInputs = [
    zlib
    libpng
    libjpeg
    curl
    SDL2
    libogg
    libvorbis
    ffmpeg
  ] ++ lib.optionals stdenv.isLinux [
    openal
  ] ++ lib.optionals stdenv.isDarwin [
    openalSoft
  ] ++ lib.optionals waylandSupport [
    wayland
    wayland-protocols
    libdecor
  ] ++ lib.optionals x11Support [
    libXi
  ];

  mesonBuildType = "release";

  mesonFlags = [
    (lib.mesonBool "anticheat-server" true)
    (lib.mesonBool "client-gtv" true)
    (lib.mesonBool "packetdup-hack" true)
    (lib.mesonBool "variable-fps" true)
    (lib.mesonEnable "wayland" waylandSupport)
    (lib.mesonEnable "x11" x11Support)
    (lib.mesonEnable "icmp-errors" stdenv.isLinux)
    (lib.mesonEnable "windows-crash-dumps" false)
  ];

  patches = [
    ./qal.patch
  ];

  meta = with lib; {
    description = "Enhanced Quake 2 client and server focused on multiplayer";
    license = licenses.gpl2;
    maintainers = [ maintainers.carlossless ];
    platforms = platforms.unix;
    homepage = "https://skuller.net/q2pro/";
  };
}
