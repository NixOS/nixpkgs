{
  fetchFromGitHub,
  fixDarwinDylibNames,
  lib,
  meson,
  ninja,
  stdenv,
  pkg-config,
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmpdclient";
  version = "2.24";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "libmpdclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VACe7/RnKgoA3qRIWmjFhCW+GVk9qUGp4+tSXMTo8Bk=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  nativeCheckInputs = [
    pkg-config
    check
  ];

  mesonFlags = [ (lib.strings.mesonBool "test" finalAttrs.finalPackage.doCheck) ];

  doCheck = true;

  meta = {
    description = "Client library for MPD (music player daemon)";
    homepage = "https://www.musicpd.org/libs/libmpdclient/";
    changelog = "https://raw.githubusercontent.com/MusicPlayerDaemon/libmpdclient/${finalAttrs.src.rev}/NEWS";
    license = with lib.licenses; [ bsd2 ];
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
