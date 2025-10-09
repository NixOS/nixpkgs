{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libX11,
  libpthreadstubs,
  libXau,
  libXdmcp,
  libXext,
  libvdpau,
  glib,
  libva,
  libGLU,
}:

stdenv.mkDerivation rec {
  pname = "libvdpau-va-gl";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "libvdpau-va-gl";
    rev = "v${version}";
    sha256 = "0asndybfv8xb0fx73sjjw5kydqrahqkm6n04lh589pbf18s5qlld";
  };

  patches = [
    # cmake-4 compatibility
    (fetchpatch {
      name = "cmake-4-1.patch";
      url = "https://github.com/i-rinat/libvdpau-va-gl/commit/30c8ac91f3aa2843f7dc1c1d167e09fad447fd91.patch?full_index=1";
      hash = "sha256-PFEqBg3NE0fVFBAW4zdDbh8eBfKyPX3BZ8P2M15Qq5A=";
    })
    (fetchpatch {
      name = "cmake-4-2.patch";
      url = "https://github.com/i-rinat/libvdpau-va-gl/commit/38c7d8fddb092824cbcdf2b11af519775930cc8b.patch?full_index=1";
      hash = "sha256-XsX/GLIS2Ce7obQJ4uVhLDtTI1TrDAGi3ECxEH6oOFI=";
    })
    (fetchpatch {
      name = "cmake-4-3.patch";
      url = "https://github.com/i-rinat/libvdpau-va-gl/commit/a845e8720d900e4bcc89e7ee16106ce63b44af0.patch?full_index=1";
      hash = "sha256-lhiZFDR2ytDmo9hQUT35IJS4KL4+nYWAOnxZlj7u3tM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libX11
    libpthreadstubs
    libXau
    libXdmcp
    libXext
    libvdpau
    glib
    libva
    libGLU
  ];

  doCheck = false; # fails. needs DRI access

  meta = with lib; {
    homepage = "https://github.com/i-rinat/libvdpau-va-gl";
    description = "VDPAU driver with OpenGL/VAAPI backend";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
