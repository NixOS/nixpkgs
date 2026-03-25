{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  runCommand,
  testers,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  autoreconfHook,
  pulseSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,
  libsidplayfp,
  makeWrapper,
  out123Support ? stdenv.hostPlatform.isDarwin,
  mpg123,
  perl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sidplayfp";
  version = "2.16.2";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "sidplayfp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zvV1BIKkJF/UAZnSgHFqNSiioUH5iB8I7SDqnWQnGj0=";
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
    tests.version = testers.testVersion {
      package =
        # sidplayfp prints its own version + libsidplayfp version, lets isolate just the one we care about
        runCommand "sidplayfp-print-version"
          {
            inherit (finalAttrs.finalPackage) pname version meta;
            nativeBuildInputs = [ makeWrapper ];
          }
          ''
            makeWrapper ${lib.getExe finalAttrs.finalPackage} $out/bin/${finalAttrs.finalPackage.meta.mainProgram} \
              --append-flags '| head -n1'
          '';
    };
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = "(a|rc)";
    };
  };

  meta = {
    description = "SID player using libsidplayfp";
    homepage = "https://github.com/libsidplayfp/sidplayfp";
    changelog = "https://github.com/libsidplayfp/sidplayfp/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl2Plus ];
    mainProgram = "sidplayfp";
    maintainers = with lib.maintainers; [
      OPNA2608
    ];
    platforms = lib.platforms.all;
  };
})
