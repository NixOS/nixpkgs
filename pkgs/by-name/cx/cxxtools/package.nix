{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  tzdata,
  autoreconfHook,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "cxxtools";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "maekitalo";
    repo = "cxxtools";
    rev = "V${version}";
    hash = "sha256-AiMVmtvI20nyv/nuHHxGH4xFnlc9AagVkKlnRlaYCPM=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/maekitalo/cxxtools/commit/b773c01fc13d2ae67abc0839888e383be23562fd.patch";
      hash = "sha256-9yRkD+vMRhc4n/Xh6SKtmllBrmfDx3IBVOtHQV6s7Tw=";
    })
    (fetchpatch {
      url = "https://github.com/maekitalo/cxxtools/commit/6e1439a108ce3892428e95f341f2d23ae32a590e.patch";
      hash = "sha256-ZnlbdWBjL9lEtNLEF/ZPa0IzvJ7i4xWI4GbY8KeA6A4=";
    })
  ];

  postPatch = ''
    substituteInPlace src/tz.cpp \
      --replace '::getenv("TZDIR")' '"${tzdata}/share/zoneinfo"'
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    openssl
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.tntnet.org/cxxtools.html";
    description = "Comprehensive C++ class library for Unix and Linux";
    platforms = lib.platforms.linux;
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.juliendehos ];
  };
}
