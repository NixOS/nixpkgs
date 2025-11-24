{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
}:

stdenv.mkDerivation rec {
  pname = "ndstool";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "devkitPro";
    repo = "ndstool";
    rev = "v${version}";
    sha256 = "sha256-121xEmbt1WBR1wi4RLw9/iLHqkpyXImXKiCNnLCYnJs=";
  };

  nativeBuildInputs = [
    autoconf
    automake
  ];

  preConfigure = "./autogen.sh";

  meta = {
    homepage = "https://github.com/devkitPro/ndstool";
    description = "Tool to unpack and repack nds rom";
    maintainers = [ lib.maintainers.marius851000 ];
    license = lib.licenses.gpl3;
    mainProgram = "ndstool";
  };
}
