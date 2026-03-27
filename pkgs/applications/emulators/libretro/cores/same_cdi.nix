{
  lib,
  alsa-lib,
  fetchFromGitHub,
  fetchpatch2,
  libGL,
  libGLU,
  mkLibretroCore,
  portaudio,
  python3,
  libx11,
}:
mkLibretroCore {
  core = "same_cdi";
  version = "0-unstable-2025-01-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "same_cdi";
    rev = "7ee1d8e9cb4307b7cd44ee1dd757e9b3f48f41d5";
    hash = "sha256-EGE3NuO0gpZ8MKPypH8rFwJiv4QsdKuIyLKVuKTcvws=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/libretro/same_cdi/pull/19
      name = "Fixes_compilation_errors_as_per_issue_9.patch";
      url = "https://github.com/libretro/same_cdi/commit/bf3212315546cdd514118a4f3ea764fd9c401091.patch?full_index=1";
      hash = "sha256-1vrMxnRtEWUt+6I/4PSfCPDIUAGKkXFd2UVr9473ngo=";
    })
  ];

  postPatch = ''
    # Fix sol2 compatibility with GCC 15 (construct -> emplace)
    # https://github.com/ThePhD/sol2/issues/1657
    sed -i 's/this->construct(std::forward<Args>(args)\.\.\.);/this->emplace(std::forward<Args>(args)...);/g' 3rdparty/sol2/sol/sol.hpp

    # Fix missing cstdint include for uint8_t
    sed -i '1i #include <cstdint>' src/lib/util/corestr.cpp
  '';

  extraNativeBuildInputs = [ python3 ];
  extraBuildInputs = [
    alsa-lib
    libGL
    libGLU
    portaudio
    libx11
  ];

  meta = {
    description = "SAME_CDI is a libretro core to play CD-i games";
    homepage = "https://github.com/libretro/same_cdi";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
  };
}
