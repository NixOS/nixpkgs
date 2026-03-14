{
  stdenv,
  lib,
  replaceVars,
  pkg-config,
  fetchurl,
  fetchpatch,
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
  runtimeShell,
  withLibao ? true,
  libao,
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
  svox,
  libsOnly ? false,
}:

let
  inherit (python3Packages) python pyxdg wrapPython;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "speech-dispatcher";
  version = "0.12.1";

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
  ++ lib.optionals withEspeak [
    espeak
    sonic
    pcaudiolib
  ]
  ++ lib.optionals withFlite [
    flite
  ]
  ++ lib.optionals withPico [
    svox
  ];

  pythonPath = [
    pyxdg
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    # Audio method falls back from left to right.
    "--with-default-audio-method=\"libao,pulse,alsa,oss\""
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
    "--with-systemduserunitdir=${placeholder "out"}/lib/systemd/user"
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
  ++ lib.optionals withEspeak [
    "--with-espeak-ng"
  ]
  ++ lib.optionals withPico [
    "--with-pico"
  ];

  postPatch = lib.optionalString withPico ''
    substituteInPlace src/modules/pico.c --replace "/usr/share/pico/lang" "${svox}/share/pico/lang"
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

  meta = {
    description =
      "Common interface to speech synthesis" + lib.optionalString libsOnly " - client libraries only";
    homepage = "https://devel.freebsoft.org/speechd";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      berce
      jtojnar
    ];
    # TODO: remove checks for `withPico` once PR #375450 is merged
    platforms = if withAlsa || withPico then lib.platforms.linux else lib.platforms.unix;
    mainProgram = "speech-dispatcher";
  };
})
