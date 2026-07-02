{
  stdenv,
  lib,
  replaceVars,
  pkg-config,
  fetchFromGitHub,
  fetchpatch,
  testers,
  nix-update-script,
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
  withPulse ? false,
  libpulseaudio,
  withAlsa ? false,
  alsa-lib,
  withOss ? false,
  withPipewire ? false,
  pipewire,
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
  inherit (python3Packages) python pyxdg wrapPython;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "speech-dispatcher";
  version = "0.12.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    repo = "speechd";
    owner = "brailcom";
    tag = finalAttrs.version;
    sha256 = "sha256-+DgbL5n4G5Hjwk5ymITwfVlSbBfI1hLjtcuRBZDGNTg=";
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
    wrapPython
  ];

  buildInputs = [
    glib
    dotconf
    libsndfile
    libao
    libpulseaudio
    python
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    systemdMinimal # libsystemd
  ]
  ++ lib.optionals withAlsa [
    alsa-lib
  ]
  ++ lib.optionals withPipewire [
    pipewire
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
    pyxdg
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    # Audio method falls back from left to right.
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ]
  ++ [
    ''--with-default-audio-method="${
      lib.concatStringsSep "," (
        lib.optional withLibao "libao"
        ++ lib.optional withPulse "pulse"
        ++ lib.optional withAlsa "alsa"
        ++ lib.optional withPipewire "pipewire"
        ++ lib.optional withOss "oss"
      )
    }"''
  ]
  ++ lib.optionals withPulse [
    "--with-pulse"
  ]
  ++ lib.optionals withAlsa [
    "--with-alsa"
  ]
  ++ lib.optionals withLibao [
    "--with-libao"
  ]
  ++ lib.optionals withOss [
    "--with-oss"
  ]
  ++ lib.optionals withPipewire [
    "--with-pipewire"
  ]
  ++ lib.optionals withEspeak [
    "--with-espeak-ng"
  ]
  ++ lib.optionals withPico [
    "--with-pico"
  ];

  postPatch = lib.optionalString withPico ''
    substituteInPlace src/modules/pico.c \
      --replace-fail "/usr/share/pico/lang" "${picotts}/share/pico/lang"
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

  passthru.updateScript = nix-update-script { };

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description =
      "Common interface to speech synthesis" + lib.optionalString libsOnly " - client libraries only";
    homepage = "https://devel.freebsoft.org/speechd";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ jtojnar ];
    # TODO: remove checks for `withPico` once PR #375450 is merged
    platforms = if withAlsa || withPico then lib.platforms.linux else lib.platforms.unix;
    mainProgram = "speech-dispatcher";
  };
})
