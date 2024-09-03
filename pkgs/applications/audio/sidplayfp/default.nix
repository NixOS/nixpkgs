{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsa-lib
, autoreconfHook
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
, libsidplayfp
, out123Support ? stdenv.hostPlatform.isDarwin
, mpg123
, perl
, pkg-config
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sidplayfp";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "sidplayfp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-07Pwh7qbw6Emr5+F89v9i2ARdSosukjjuarJ+uZR7xY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
  ];

  buildInputs = [
    libsidplayfp
  ] ++ lib.optionals alsaSupport [
    alsa-lib
  ] ++ lib.optionals pulseSupport [
    libpulseaudio
  ] ++ lib.optionals out123Support [
    mpg123
  ];

  configureFlags = [
    (lib.strings.withFeature out123Support "out123")
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "SID player using libsidplayfp";
    homepage = "https://github.com/libsidplayfp/sidplayfp";
    license = with licenses; [ gpl2Plus ];
    mainProgram = "sidplayfp";
    maintainers = with maintainers; [ dezgeg OPNA2608 ];
    platforms = platforms.all;
  };
})
