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
  version = "3.14.8";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    rev = "v${version}";
    hash = "sha256-XnibLlwUspI2aveWfMg/TOe59vK6Z2WEnF7gafUmx6E=";
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
