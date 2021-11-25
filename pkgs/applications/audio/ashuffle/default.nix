{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, meson
, ninja
, libmpdclient
}:

stdenv.mkDerivation rec {
  pname = "ashuffle";
  version = "3.12.3";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    rev = "v${version}";
    sha256 = "sha256-y2DH8SjSZ8hV6DAC4uDw5Wn7O0oj/WIhIr4BE/+jUxM=";
    fetchSubmodules = true;
  };

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake pkg-config meson ninja ];
  buildInputs = [ libmpdclient ];

  meta = with lib; {
    homepage = "https://github.com/joshkunz/ashuffle";
    description = "Automatic library-wide shuffle for mpd";
    maintainers = [ maintainers.tcbravo ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
