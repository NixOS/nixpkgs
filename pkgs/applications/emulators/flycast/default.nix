{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, makeWrapper
, alsa-lib
, curl
, egl-wayland
, libao
, libdecor
, libevdev
, libffi
, libGL
, libpulseaudio
, libX11
, libXext
, libxkbcommon
, libzip
, mesa
, miniupnpc
, udev
, vulkan-headers
, vulkan-loader
, wayland
, zlib
}:

stdenv.mkDerivation rec {
  pname = "flycast";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "V${version}";
    sha256 = "sha256-PRInOqg9OpaUVLwSj1lOxDtjpVaYehkRsp0jLrVKPyY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    curl
    egl-wayland
    libao
    libdecor
    libevdev
    libffi
    libGL
    libpulseaudio
    libX11
    libXext
    libxkbcommon
    libzip
    mesa # for libgbm
    miniupnpc
    udev
    vulkan-headers
    wayland
    zlib
  ];

  postFixup = ''
    wrapProgram $out/bin/flycast --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/flyinghead/flycast";
    changelog = "https://github.com/flyinghead/flycast/releases/tag/v${version}";
    description = "A multi-platform Sega Dreamcast, Naomi and Atomiswave emulator";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = [ maintainers.ivar ];
  };
}
