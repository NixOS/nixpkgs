{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "rlottie";
  version = "0.2-unstable-2025-10-01";

  src = fetchFromGitHub {
    owner = "Samsung";
    repo = "rlottie";
    rev = "671c561130ead1c6e44805a7ec1263573a3440fd";
    hash = "sha256-od3zatv4ZxUIoLkwy0TT8lAsDcjoPS4plci+ZDyz34Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64
  ) "-U__ARM_NEON__";

  meta = with lib; {
    homepage = "https://github.com/Samsung/rlottie";
    description = "Platform independent standalone c++ library for rendering vector based animations and art in realtime";
    license = with licenses; [
      mit
      bsd3
      mpl11
      ftl
    ];
    platforms = platforms.all;
    maintainers = with maintainers; [ CRTified ];
  };
}
