{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, meson
, ninja
, libmpdclient
, yaml-cpp
, darwin
}:

stdenv.mkDerivation rec {
  pname = "ashuffle";
  version = "3.14.3";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    rev = "v${version}";
    hash = "sha256-C7LClzVganE2DvucHw6euNRw2r36vhhCQlhWlkwWPwk=";
    fetchSubmodules = true;
  };

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake pkg-config meson ninja ];
  buildInputs = [ libmpdclient yaml-cpp ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.CoreFoundation ];

  mesonFlags = [ "-Dunsupported_use_system_yamlcpp=true" ];

  meta = with lib; {
    homepage = "https://github.com/joshkunz/ashuffle";
    description = "Automatic library-wide shuffle for mpd";
    maintainers = [ maintainers.tcbravo ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
