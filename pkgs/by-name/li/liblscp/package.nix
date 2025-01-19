{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "liblscp";
  version = "1.0.0";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/${pname}-${version}.tar.gz";
    sha256 = "sha256-ZaPfB3Veg1YCBHieoK9fFqL0tB4PiNsY81oJmn2rd/I=";
  };

  postPatch = ''
    # fix prefix to only appear once
    substituteInPlace CMakeLists.txt \
      --replace-fail '"''${CONFIG_PREFIX}/' '"'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://www.linuxsampler.org";
    description = "LinuxSampler Control Protocol (LSCP) wrapper library";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
