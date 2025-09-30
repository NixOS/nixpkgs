{
  lib,
  stdenv,
  fetchurl,
  libX11,
  libxcb,
  pkg-config,
  xcbutil,
}:

stdenv.mkDerivation rec {
  pname = "libstartup-notification";
  version = "0.12";
  src = fetchurl {
    url = "https://www.freedesktop.org/software/startup-notification/releases/startup-notification-${version}.tar.gz";
    sha256 = "3c391f7e930c583095045cd2d10eb73a64f085c7fde9d260f2652c7cb3cfbe4a";
  };

  configureFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "lf_cv_sane_realloc=yes"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libX11
    libxcb
    xcbutil
  ];

  meta = {
    homepage = "https://www.freedesktop.org/software/startup-notification";
    description = "Application startup notification and feedback library";
    license = lib.licenses.lgpl2;
  };
}
