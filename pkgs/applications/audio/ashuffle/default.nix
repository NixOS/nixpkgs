{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, mpd_clientlib, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "ashuffle";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    rev = "v${version}";
    sha256 = "09q6lwgc1dc8bg1mb9js9qz3xcsxph3548nxzvyb4v8111gixrp7";
    fetchSubmodules = true;
  };

  dontUseCmakeConfigure = true;
  nativeBuildInputs = [ cmake pkg-config meson ninja ];
  buildInputs = [ mpd_clientlib ];

  meta = with lib; {
    homepage = "https://github.com/joshkunz/ashuffle";
    description = "Automatic library-wide shuffle for mpd";
    maintainers = [ maintainers.tcbravo ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
