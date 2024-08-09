{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
, cmake
, pkg-config
, makeWrapper
, alsa-lib
, curl
, libao
, libpulseaudio
, libzip
, lua
, miniupnpc
, SDL2
, vulkan-loader
}:

stdenv.mkDerivation rec {
  pname = "flycast";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "flyinghead";
    repo = "flycast";
    rev = "v${version}";
    hash = "sha256-YFLSUaEikwLPglHh3t8sHiKHRn5cchKzzkJlZDdgVsU=";
    fetchSubmodules = true;
  };

  patches = [
    # miniupnp: add support for api version 18
    (fetchpatch2 {
      url = "https://github.com/flyinghead/flycast/commit/71982eda7a038e24942921e558845103b6c12326.patch?full_index=1";
      hash = "sha256-5fFCgX7MfCqW7zxXJuHt9js+VTZZKEQHRYuWh7MTKzI=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    curl
    libao
    libpulseaudio
    libzip
    lua
    miniupnpc
    SDL2
  ];

  cmakeFlags = [
    "-DUSE_HOST_SDL=ON"
  ];

  postFixup = ''
    wrapProgram $out/bin/flycast --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/flyinghead/flycast";
    changelog = "https://github.com/flyinghead/flycast/releases/tag/v${version}";
    description = "Multi-platform Sega Dreamcast, Naomi and Atomiswave emulator";
    mainProgram = "flycast";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
