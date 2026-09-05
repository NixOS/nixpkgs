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
  version = "2.27";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "libmpdclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TQ6vk+hQ/GgoxaMz66YG7jWqjHCkTiTk/h2P2obVypw=";
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
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
