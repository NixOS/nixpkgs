{
  stdenv,
  lib,
  replaceVars,
  pkg-config,
  fetchurl,
  fetchpatch,
  testers,
  python3Packages,
  gettext,
  itstool,
  libtool,
  texinfo,
  systemdMinimal,
  util-linux,
  autoreconfHook,
  glib,
  dotconf,
  libsndfile,

  withLibao ? true,
  libao,

  withPipewire ? true,
  pipewire,

  withPulse ? false,
  libpulseaudio,

  withAlsa ? false,
  alsa-lib,

  withOss ? false,

  withFlite ? true,
  flite,

  withEspeak ? true,
  espeak,
  sonic,
  pcaudiolib,
  mbrola,

  withPico ? true,
  picotts,

  libsOnly ? false,
}:

let
  withSupports =
    lib.optional withPulse "pulse"
    ++ lib.optional withLibao "libao"
    ++ lib.optional withPipewire "pipewire"
    ++ lib.optional withAlsa "alsa"
    ++ lib.optional withOss "oss"
    ++ lib.optional withEspeak "espeak-ng"
    ++ lib.optional withFlite "flite"
    ++ lib.optional withPico "pico";
  hasOptionalSupports = withSupports != [ ];
  withOptionalSupports = lib.optionalString hasOptionalSupports " with ${lib.strings.concatStringsSep " and " withSupports} supports";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "speech-dispatcher";
  version = "0.12.1";

  __structuredAttrs = true;
  strictDeps = true;
  src = fetchurl {
    url = "https://github.com/brailcom/speechd/releases/download/${finalAttrs.version}/speech-dispatcher-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-sUpSONKH0tzOTdQrvWbKZfoijn5oNwgmf3s0A297pLQ=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      utillinux = util-linux;
      # patch context
      bindir = null;
    })
    (fetchpatch {
      name = "use-binsh.patch";
      url = "https://github.com/brailcom/speechd/commit/66d5fe65cffd4c0ce9cfb4c6d292866ed8726999.diff?full_index=1";
      hash = "sha256-7R5BH6QmxovvtXoH/T76qu6YMfm1HE+CA0eB0mzwmfY=";
    })
  ]
  ++ lib.optionals (withEspeak && espeak.mbrolaSupport) [
    # Replace FHS paths.
    (replaceVars ./fix-mbrola-paths.patch {
      inherit mbrola;
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    libtool
    itstool
    texinfo
    python3Packages.wrapPython
  ];

  buildInputs = [
    glib
    dotconf
    libsndfile
    libao
    libpulseaudio
    python3Packages.python
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    systemdMinimal # libsystemd
  ]
  ++ lib.optionals withPipewire [
    pipewire
  ]
  ++ lib.optionals withAlsa [
    alsa-lib
  ]
  ++ lib.optionals withEspeak [
    espeak
    sonic
    pcaudiolib
  ]
  ++ lib.optionals withFlite [
    flite
  ]
  ++ lib.optionals withPico [
    picotts
  ];

  pythonPath = [
    python3Packages.pyxdg
  ];

  configureFlags =
    let
      inherit (lib) withFeature;
    in
    [
      "--sysconfdir=/etc"
      # Audio method falls back from left to right.
      ''--with-default-audio-method="${
        lib.concatStringsSep "," (
          lib.optional withLibao "libao"
          ++ lib.optional withPulse "pulse"
          ++ lib.optional withAlsa "alsa"
          ++ lib.optional withPipewire "pipewire"
          ++ lib.optional withOss "oss"
        )
      }"''
      "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
      "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
      (withFeature withPulse "pulse")
      (withFeature withLibao "libao")
      (withFeature withPipewire "pipewire")
      (withFeature withAlsa "alsa")
      (withFeature withOss "oss")
      (withFeature withEspeak "espeak-ng")
      (withFeature withFlite "flite")
      (withFeature withPico "pico")
    ];

  postPatch = lib.optionalString withPico ''
    substituteInPlace src/modules/pico.c --replace-fail "/usr/share/pico/lang" "${picotts}/share/pico/lang"
  '';

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  postInstall =
    if libsOnly then
      ''
        rm -rf $out/{bin,etc,lib/speech-dispatcher,lib/systemd,libexec,share}
      ''
    else
      ''
        wrapPythonPrograms
      '';

  enableParallelBuilding = true;
  passthru = {
    tests = lib.optionalAttrs (!libsOnly) {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description =
      "Common high-level interface to speech synthesis"
      + withOptionalSupports
      + lib.optionalString libsOnly " - client libraries only";
    homepage = "https://devel.freebsoft.org/speechd";
    changelog = "https://github.com/brailcom/speechd/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    # TODO: remove checks for `withPico` once PR #375450 is merged
    platforms = if withAlsa || withPico then lib.platforms.linux else lib.platforms.unix;
    mainProgram = "speech-dispatcher";
  };
})
