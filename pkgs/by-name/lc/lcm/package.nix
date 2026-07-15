{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lcm";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "lcm-proj";
    repo = "lcm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-72fytJY+uXEHGdZ7N+0g+JK7ALb2e2ZtJuvhiGIMHiA=";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    glib
  ];

  meta = {
    description = "Lightweight Communications and Marshalling (LCM)";
    homepage = "https://github.com/lcm-proj/lcm";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ kjeremy ];
    platforms = lib.platforms.unix;
  };
})
