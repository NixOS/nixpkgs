{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, meson
, ninja
, libmpdclient
, yaml-cpp
}:

stdenv.mkDerivation rec {
  pname = "ashuffle";
  version = "3.13.6";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    rev = "v${version}";
    sha256 = "sha256-8XjLs4MI5MXvA6veCoTAj8tlYDe7YTggutO3F9eNyMM=";
    fetchSubmodules = true;
  };

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake pkg-config meson ninja ];
  buildInputs = [ libmpdclient yaml-cpp ];

  mesonFlags = [ "-Dunsupported_use_system_yamlcpp=true" ];

  meta = with lib; {
    homepage = "https://github.com/joshkunz/ashuffle";
    description = "Automatic library-wide shuffle for mpd";
    maintainers = [ maintainers.tcbravo ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
