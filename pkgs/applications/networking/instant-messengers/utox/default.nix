{ stdenv, fetchFromGitHub, cmake, pkgconfig, libtoxcore, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, utillinux, git, libsodium, libopus, check }:

stdenv.mkDerivation rec {
  name = "utox-${version}";

  version = "0.16.1";

  src = fetchFromGitHub {
    owner  = "uTox";
    repo   = "uTox";
    rev    = "v${version}";
    sha256 = "0ak10925v67yaga2pw9yzp0xkb5j1181srfjdyqpd29v8mi9j828";
  };

  buildInputs = [
    libtoxcore dbus libvpx libX11 openal freetype
    libv4l libXrender fontconfig libXext libXft filter-audio
    libsodium libopus
  ];

  nativeBuildInputs = [
    cmake git pkgconfig check
  ];

  cmakeFlags = [
    "-DENABLE_UPDATER=OFF"
  ] ++ stdenv.lib.optional (!doCheck) "-DENABLE_TESTS=OFF";

  doCheck = true;

  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    homepage = https://github.com/uTox/uTox;
    license = licenses.gpl3;
    maintainers = with maintainers; [ domenkozar jgeerds ];
    platforms = platforms.all;
  };
}
