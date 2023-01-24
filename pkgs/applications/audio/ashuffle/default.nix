{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, meson
, ninja
, libmpdclient
, libyamlcpp
}:

stdenv.mkDerivation rec {
  pname = "ashuffle";
  version = "3.13.4";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    rev = "v${version}";
    sha256 = "sha256-J6NN0Rsc9Zw9gagksDlwpwEErs+4XmrGF9YHKlAE1FA=";
    fetchSubmodules = true;
  };

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake pkg-config meson ninja ];
  buildInputs = [ libmpdclient libyamlcpp ];

  mesonFlags = [ "-Dunsupported_use_system_yamlcpp=true" ];

  meta = with lib; {
    homepage = "https://github.com/joshkunz/ashuffle";
    description = "Automatic library-wide shuffle for mpd";
    maintainers = [ maintainers.tcbravo ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
