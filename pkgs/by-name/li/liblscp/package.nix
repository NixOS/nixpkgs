{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "liblscp";
  version = "1.0.1";

  src = fetchurl {
    url = "https://download.linuxsampler.org/packages/${pname}-${version}.tar.gz";
    sha256 = "sha256-21SjPA5emMRKEQIukhg7r3uXfnByEpNkGhCepNu09sc=";
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

  meta = with lib; {
    homepage = "http://www.linuxsampler.org";
    description = "LinuxSampler Control Protocol (LSCP) wrapper library";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
