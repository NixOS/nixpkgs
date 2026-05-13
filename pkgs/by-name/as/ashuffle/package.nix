{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  meson,
  ninja,
  libmpdclient,
  yaml-cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ashuffle";
  version = "3.14.10";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nvmyup9hW/kI7Wwo5+1/FEoHd4kfMvYbttI8nJkLfVE=";
    fetchSubmodules = true;
  };

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [
    cmake
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    libmpdclient
    yaml-cpp
  ];

  mesonFlags = [ "-Dunsupported_use_system_yamlcpp=true" ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = "-framework CoreFoundation";
  };

  meta = {
    homepage = "https://github.com/joshkunz/ashuffle";
    description = "Automatic library-wide shuffle for mpd";
    maintainers = [ lib.maintainers.tcbravo ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    mainProgram = "ashuffle";
  };
})
