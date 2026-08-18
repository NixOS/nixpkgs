{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  runCommand,
  testers,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  coreaudioSupport ? stdenv.hostPlatform.isDarwin,
  jackSupport ? stdenv.hostPlatform.isUnix,
  pulseSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib,
  autoreconfHook,
  jack2,
  libpulseaudio,
  libsidplayfp,
  makeWrapper,
  perl,
  pkg-config,
}:

let
  miniaudioBackends = [
    "NULL"
  ]
  ++ lib.optional alsaSupport "ALSA"
  ++ lib.optional coreaudioSupport "COREAUDIO"
  ++ lib.optional jackSupport "JACK"
  ++ lib.optional pulseSupport "PULSEAUDIO";

  miniaudioPkgconfigs =
    lib.optional alsaSupport "alsa"
    ++ lib.optional jackSupport "jack"
    ++ lib.optional pulseSupport "libpulse";

  miniaudioNeedsPkgconfigs = builtins.length miniaudioPkgconfigs > 0;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sidplayfp";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "sidplayfp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wkZ/iJzz1QikNEaI00PFHaeewOrP+lYHF/iaws1aSro=";
  };

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace-fail \
        'AM_CPPFLAGS =' \
        "AM_CPPFLAGS = ${
          toString (
            [
              # Don't use dlopen() for audio-related libraries
              "-DMA_NO_RUNTIME_LINKING"

              # Only selected backends
              "-DMA_ENABLE_ONLY_SPECIFIC_BACKENDS"
            ]
            ++ map (backend: "-DMA_ENABLE_" + backend) miniaudioBackends
            ++ lib.optionals miniaudioNeedsPkgconfigs [
              "$(pkg-config --cflags ${toString miniaudioPkgconfigs})"
            ]
          )
        }" \
      --replace-fail 'src_sidplayfp_LDADD =' "src_sidplayfp_LDFLAGS = ${
        toString (
          lib.optionals miniaudioNeedsPkgconfigs [
            "$(pkg-config --libs ${toString miniaudioPkgconfigs})"
          ]
          ++ lib.optionals coreaudioSupport [
            "-framework CoreFoundation"
            "-framework CoreAudio"
            "-framework AudioToolbox"
          ]
        )
      }"
  '';

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
  ++ lib.optionals jackSupport [
    jack2
  ]
  ++ lib.optionals pulseSupport [
    libpulseaudio
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
      ignoredVersions = "[a-zA-Z]";
    };
  };

  meta = {
    description = "SID player using libsidplayfp";
    homepage = "https://github.com/libsidplayfp/sidplayfp";
    changelog = "https://github.com/libsidplayfp/sidplayfp/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "sidplayfp";
    maintainers = with lib.maintainers; [
      OPNA2608
    ];
    platforms = lib.platforms.all;
  };
})
