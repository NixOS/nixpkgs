{
  config,
  lib,
  stdenv,
  alsa-lib,
  autoPatchelfHook,
  chafa,
  curl,
  faad2,
  fetchFromGitHub,
  fftwFloat,
<<<<<<< HEAD
  gdk-pixbuf,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  glib,
  libogg,
  libopus,
  libjack2,
  libpulseaudio,
  libvorbis,
  nix-update-script,
  opusfile,
  pkg-config,
  taglib,
  versionCheckHook,

  withALSA ? stdenv.hostPlatform.isLinux,
  withJACK ? false,
  withPulseaudio ? config.pulseaudio or stdenv.hostPlatform.isLinux,
}:

let
  uppercaseFirst =
    x: (lib.toUpper (lib.substring 0 1 x)) + (lib.substring 1 ((lib.strings.stringLength x) - 1) x);
in

stdenv.mkDerivation (finalAttrs: {
  pname = "kew";
<<<<<<< HEAD
  version = "3.7.2";
=======
  version = "3.6.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-MCmOd8c2owIjtXkRUso3+4C0Hj/5HoOLa97E9+21FGA=";
=======
    hash = "sha256-PhNBAy+XS1wpU91GNoRc4jume9razD03xmmUER0p8I0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(shell uname -s)' '${uppercaseFirst stdenv.hostPlatform.parsed.kernel.name}' \
<<<<<<< HEAD
      --replace-fail '$(shell uname -m)' '${stdenv.hostPlatform.parsed.cpu.name}' \
      --replace-fail 'LANGDIRPREFIX = /usr' 'LANGDIRPREFIX = ${placeholder "out"}'
=======
      --replace-fail '$(shell uname -m)' '${stdenv.hostPlatform.parsed.cpu.name}'
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    fftwFloat.dev
    chafa
    curl.dev
<<<<<<< HEAD
    gdk-pixbuf
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    glib.dev
    libopus
    opusfile
    libvorbis
    taglib
    faad2
    libogg
  ];

  runtimeDependencies =
    lib.optionals withPulseaudio [
      libpulseaudio
    ]
    ++ lib.optionals (withALSA || withJACK) [
      alsa-lib
    ]
    ++ lib.optionals withJACK [
      libjack2
    ];

  enableParallelBuilding = true;

  installFlags = [
    "MAN_DIR=${placeholder "out"}/share/man"
    "PREFIX=${placeholder "out"}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Command-line music player for Linux";
    homepage = "https://github.com/ravachol/kew";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      demine
      matteopacini
    ];
    mainProgram = "kew";
  };
})
