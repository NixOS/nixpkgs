{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
  libjack2,
  libpulseaudio,
}:

stdenv.mkDerivation rec {
  version = "2.0.0";
  pname = "libsoundio";

  src = fetchFromGitHub {
    owner = "andrewrk";
    repo = "libsoundio";
    rev = version;
    sha256 = "12l4rvaypv87vigdrmjz48d4d6sq4gfxf5asvnc4adyabxb73i4x";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libjack2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libpulseaudio
    alsa-lib
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DBUILD_TESTS=OFF"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-strict-prototypes";

  meta = with lib; {
    description = "Cross platform audio input and output";
    homepage = "http://libsound.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.andrewrk ];
  };
}
