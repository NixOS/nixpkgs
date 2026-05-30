{
  fetchurl,
  stdenv,
  lib,
  pkg-config,
  boost,
  cairo,
  fontconfig,
  libsigcxx,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cairomm";
  version = "1.14.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.cairographics.org/releases/cairomm-${finalAttrs.version}.tar.xz";
    sha256 = "cBNiA1QMiE6Jzhye37Y2m5lTk39s1ZbZfHjJdYpdSNs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost # for tests
    fontconfig
  ];

  propagatedBuildInputs = [
    cairo
    libsigcxx
  ];

  mesonFlags = [
    "-Dbuild-tests=true"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "C++ bindings for the Cairo vector graphics library";
    homepage = "https://www.cairographics.org/";
    license = with lib.licenses; [
      lgpl2Plus
      mpl10
    ];
    platforms = lib.platforms.unix;
  };
})
