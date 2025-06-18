{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libjpeg,
  openssl,
  zlib,
  libgcrypt,
  libpng,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvncserver";
  version = "0.9.15";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "LibVNC";
    repo = "libvncserver";
    tag = "LibVNCServer-${finalAttrs.version}";
    hash = "sha256-a3acEjJM+ZA9jaB6qZ/czjIfx/L3j71VjJ6mtlqYcSw=";
  };

  patches = [
    # fix generated pkg-config files
    ./pkgconfig.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [ (lib.cmakeBool "WITH_SYSTEMD" withSystemd) ];

  buildInputs =
    [
      libjpeg
      openssl
      libgcrypt
      libpng
    ]
    ++ lib.optionals withSystemd [
      systemd
    ];

  propagatedBuildInputs = [
    zlib
  ];

  meta = with lib; {
    description = "VNC server library";
    homepage = "https://libvnc.github.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.unix;
  };
})
