{
  stdenv,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  pkg-config,
  lib,
  qttools,
  fribidi,
  libunibreak,
}:

mkDerivation rec {
  pname = "coolreader";
  version = "3.2.57";

  src = fetchFromGitHub {
    owner = "buggins";
    repo = "coolreader";
    rev = "cr${version}";
    sha256 = "sha256-ZfgaLCLvBU6xP7nx7YJTsJSpvpdQgLpSMWH+BsG8E1g=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    qttools
    fribidi
    libunibreak
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/buggins/coolreader";
    description = "Cross platform open source e-book reader";
    mainProgram = "cr3";
    license = licenses.gpl2Plus; # see https://github.com/buggins/coolreader/issues/80
    maintainers = [ ];
    platforms = platforms.all;
  };
}
