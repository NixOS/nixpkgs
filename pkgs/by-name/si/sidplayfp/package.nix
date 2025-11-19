{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  autoreconfHook,
  pulseSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  libsidplayfp,
  out123Support ? stdenv.hostPlatform.isDarwin,
  mpg123,
  perl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sidplayfp";
  version = "2.15.2";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "sidplayfp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XUf4lqWwNC0bYSb1AdX2zZ46+0Ki1001XAjFOh7EAJ0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
  ];

  buildInputs = [
    libsidplayfp
  ]
  ++ lib.optionals alsaSupport [
    alsa-lib
  ]
  ++ lib.optionals pulseSupport [
    libpulseaudio
  ]
  ++ lib.optionals out123Support [
    mpg123
  ];

  configureFlags = [
    (lib.strings.withFeature out123Support "out123")
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "SID player using libsidplayfp";
    homepage = "https://github.com/libsidplayfp/sidplayfp";
    changelog = "https://github.com/libsidplayfp/sidplayfp/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "sidplayfp";
    maintainers = with lib.maintainers; [
      dezgeg
      OPNA2608
    ];
    platforms = lib.platforms.all;
  };
})
