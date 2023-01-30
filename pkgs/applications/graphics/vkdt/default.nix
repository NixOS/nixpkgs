{ lib
, stdenv
, fetchurl
, vulkan-headers
, vulkan-tools
, vulkan-loader
, glslang
, glfw
, libjpeg
, pkg-config
, rsync
, cmake
, clang
, llvm
, llvmPackages
, pugixml
, freetype
, exiv2
, ffmpeg
, libvorbis
, libmad
}:

stdenv.mkDerivation rec {
  pname = "vkdt";
  version = "0.5.3";

  src = fetchurl {
    url = "https://github.com/hanatos/${pname}/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-7b9mowMOdA4holdb5zUIqOGkB0/xB6AvJOfxA6IIfRc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    clang
    cmake
    glslang
    llvm
    llvmPackages.openmp
    pkg-config
    rsync
  ];

  buildInputs = [
    exiv2
    ffmpeg
    freetype
    glfw
    libjpeg
    libmad
    libvorbis
    llvmPackages.openmp
    pugixml
    vulkan-headers
    vulkan-loader
    vulkan-tools
  ];

  dontUseCmakeConfigure = true;

  makeFlags = [ "DESTDIR=$(out)" "prefix=" ];

  meta = with lib; {
    description = "A vulkan-powered raw image processor";
    homepage = "https://github.com/hanatos/vkdt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ paperdigits ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
