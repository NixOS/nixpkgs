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

stdenv.mkDerivation rec {
  pname = "ashuffle";
  version = "3.14.9";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    tag = "v${version}";
    hash = "sha256-HQ4+vyTvX0mhfuRclbiC+MvllV3300ztAwL0IxrUiC8=";
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

  meta = with lib; {
    homepage = "https://github.com/joshkunz/ashuffle";
    description = "Automatic library-wide shuffle for mpd";
    maintainers = [ maintainers.tcbravo ];
    platforms = platforms.unix;
    license = licenses.mit;
    mainProgram = "ashuffle";
  };
}
