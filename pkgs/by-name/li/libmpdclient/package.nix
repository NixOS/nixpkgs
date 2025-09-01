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
  version = "2.23";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "libmpdclient";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8/BE8K3e6U9i8/ByfKaCQgzcWFXOGGoES3gYoTx+jQg=";
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
