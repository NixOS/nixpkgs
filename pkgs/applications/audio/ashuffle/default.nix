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
  version = "3.12.5";

  src = fetchFromGitHub {
    owner = "joshkunz";
    repo = "ashuffle";
    rev = "v${version}";
    sha256 = "sha256-dPgv6EzRxRdHkGvys601Bkg9Srd8oEjoE9jbAin74Vk=";
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
