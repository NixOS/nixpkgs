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
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    rev = "v${version}";
    sha256 = "103jhajqwryiaf52qqgshajcnsxsz4l8gn3sz6bxs7k0yq5x1knr";
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
