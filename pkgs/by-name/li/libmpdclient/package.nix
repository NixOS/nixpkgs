{ fetchFromGitHub
, fixDarwinDylibNames
, lib
, meson
, ninja
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmpdclient";
  version = "2.22";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "libmpdclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KF8IR9YV6b9ro+L9m6nHs1IggakEZddfcBKm/oKCVZY=";
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
