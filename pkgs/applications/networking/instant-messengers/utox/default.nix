{ stdenv, lib, fetchFromGitHub, check, cmake, pkgconfig
, libtoxcore, filter-audio, dbus, libvpx, libX11, openal, freetype, libv4l
, libXrender, fontconfig, libXext, libXft, libsodium, libopus }:

stdenv.mkDerivation rec {
  name = "utox-${version}";

  version = "0.17.0";

  src = fetchFromGitHub {
    owner  = "uTox";
    repo   = "uTox";
    rev    = "v${version}";
    sha256 = "12wbq883il7ikldayh8hm0cjfrkp45vn05xx9s1jbfz6gmkidyar";
    fetchSubmodules = true;
  };

  buildInputs = [
    libtoxcore dbus libvpx libX11 openal freetype
    libv4l libXrender fontconfig libXext libXft filter-audio
    libsodium libopus
  ];

  nativeBuildInputs = [
    cmake pkgconfig
  ];

  cmakeFlags = [
    "-DENABLE_AUTOUPDATE=OFF"
    "-DENABLE_TESTS=${if doCheck then "ON" else "OFF"}"
  ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkInputs = [ check ];

  meta = with stdenv.lib; {
    description = "Lightweight Tox client";
    homepage = https://github.com/uTox/uTox;
    license = licenses.gpl3;
    maintainers = with maintainers; [ domenkozar jgeerds ];
    platforms = platforms.all;
  };
}
