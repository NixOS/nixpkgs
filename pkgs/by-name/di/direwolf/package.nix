{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  alsa-lib,
  avahi,
  gpsd,
  gpsdSupport ? false,
  hamlib_4,
  hamlib ? hamlib_4,
  hamlibSupport ? true,
  hidapi,
  libcap,
  libgpiod,
  libusb1,
  perl,
  pkg-config,
  portaudio,
  python3,
  sndio,
  espeak,
  udev,
  udevCheckHook,
  versionCheckHook,
  nix-update-script,
  extraScripts ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "direwolf";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "wb2osz";
    repo = "direwolf";
    tag = finalAttrs.version;
    hash = "sha256-CCJr3l4RxYZLrdCRwio64EzpDyErlV9JDOXD6TH8p9o=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    pkg-config
    udevCheckHook
  ];
  buildInputs = [
    hidapi
    libusb1
    portaudio
    sndio
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    avahi
    udev
    libcap
    libgpiod
  ]
  ++ lib.optionals gpsdSupport [ gpsd ]
  ++ lib.optionals hamlibSupport [ hamlib ]
  ++ lib.optionals extraScripts [
    python3
    perl
    espeak
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];

  preConfigure = lib.optionals (!extraScripts) ''
    echo "" > scripts/CMakeLists.txt
  '';

  # TODO: It would be great if we could make these configurable
  postPatch = ''
    substituteInPlace conf/CMakeLists.txt \
      --replace-fail /etc/udev/rules.d/ $out/lib/udev/rules.d/ \
      --replace-fail /usr/lib/udev/rules.d/ $out/lib/udev/rules.d/
    substituteInPlace src/symbols.c \
      --replace-fail /usr/share/direwolf/symbols-new.txt $out/share/direwolf/symbols-new.txt \
      --replace-fail /opt/local/share/direwolf/symbols-new.txt $out/share/direwolf/symbols-new.txt
    substituteInPlace src/deviceid.c \
      --replace-fail /usr/share/direwolf/tocalls.yaml $out/share/direwolf/tocalls.yaml \
      --replace-fail /opt/local/share/direwolf/tocalls.yaml $out/share/direwolf/tocalls.yaml
    substituteInPlace cmake/cpack/direwolf.desktop.in \
      --replace-fail 'Terminal=false' 'Terminal=true' \
      --replace-fail 'Exec=@APPLICATION_DESKTOP_EXEC@' 'Exec=direwolf'
  ''
  + lib.optionalString extraScripts ''
    patchShebangs scripts/dwespeak.sh
    substituteInPlace scripts/dwespeak.sh \
      --replace-fail espeak ${lib.getBin espeak}
  '';

  doInstallCheck = true;

  versionCheckProgramArg = [ "-u" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Soundcard Packet TNC, APRS Digipeater, IGate, APRStt gateway";
    homepage = "https://github.com/wb2osz/direwolf/";
    mainProgram = "direwolf";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      lasandell
      sarcasticadmin
      pandapip1
    ];
  };
})
