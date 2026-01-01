{
  stdenv,
  lib,
  replaceVars,
  pkg-config,
  fetchurl,
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
<<<<<<< HEAD
  runtimeShell,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    "--sysconfdir=/etc"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    substituteInPlace src/modules/generic.c --replace-fail "/bin/bash" "${runtimeShell}"
  '';

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

=======
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description =
      "Common interface to speech synthesis" + lib.optionalString libsOnly " - client libraries only";
    homepage = "https://devel.freebsoft.org/speechd";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description =
      "Common interface to speech synthesis" + lib.optionalString libsOnly " - client libraries only";
    homepage = "https://devel.freebsoft.org/speechd";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      berce
      jtojnar
    ];
    # TODO: remove checks for `withPico` once PR #375450 is merged
<<<<<<< HEAD
    platforms = if withAlsa || withPico then lib.platforms.linux else lib.platforms.unix;
=======
    platforms = if withAlsa || withPico then platforms.linux else platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "speech-dispatcher";
  };
})
