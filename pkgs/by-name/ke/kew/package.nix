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
  version = "3.5.3";

  src = fetchFromGitHub {
    owner = "ravachol";
    repo = "kew";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7bO9IvSTJJKiNYQzcTSI2Ugjhw1ibbyE5/fe6EDYqvI=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(shell uname -s)' '${uppercaseFirst stdenv.hostPlatform.parsed.kernel.name}' \
      --replace-fail '$(shell uname -m)' '${stdenv.hostPlatform.parsed.cpu.name}'
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

  versionCheckProgramArg = "--version";
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
