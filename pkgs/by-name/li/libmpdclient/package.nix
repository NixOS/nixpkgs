{ fetchFromGitHub
, fixDarwinDylibNames
, lib
, meson
, ninja
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmpdclient";
  version = "2.21";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "libmpdclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U9K/4uivK5lx/7mG71umKGzP/KWgnexooF7weGu4B78=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  meta = {
    description = "Client library for MPD (music player daemon)";
    homepage = "https://www.musicpd.org/libs/libmpdclient/";
    changelog = "https://raw.githubusercontent.com/MusicPlayerDaemon/libmpdclient/${finalAttrs.src.rev}/NEWS";
    license = with lib.licenses; [ bsd2 ];
    maintainers = with lib.maintainers; [ AndersonTorres ehmry ];
    platforms = lib.platforms.unix;
  };
})
