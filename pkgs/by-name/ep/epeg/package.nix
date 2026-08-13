{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libtool,
  autoconf,
  automake,
  libjpeg,
  libexif,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "epeg";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "mattes";
    repo = "epeg";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-lttqarR8gScNIlSrc5uU3FLfvwxxJ2A1S4oESUW7oIw=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    libtool
    autoconf
    automake
  ];

  propagatedBuildInputs = [
    libjpeg
    libexif
  ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    homepage = "https://github.com/mattes/epeg";
    description = "Insanely fast JPEG/ JPG thumbnail scaling";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.mit-enna;
    maintainers = with lib.maintainers; [ nh2 ];
    mainProgram = "epeg";
  };
})
