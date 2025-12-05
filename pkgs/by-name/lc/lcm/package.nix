{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "lcm";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "lcm-proj";
    repo = "lcm";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Lightweight Communications and Marshalling (LCM)";
    homepage = "https://github.com/lcm-proj/lcm";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ kjeremy ];
    platforms = lib.platforms.unix;
  };
}
