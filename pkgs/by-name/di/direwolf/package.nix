{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
  gpsd,
  gpsdSupport ? false,
  hamlib_4,
  hamlib ? hamlib_4,
  hamlibSupport ? true,
  perl,
  portaudio,
  python3,
  espeak,
  udev,
  udevCheckHook,
  versionCheckHook,
  nix-update-script,
  extraScripts ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "direwolf";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "wb2osz";
    repo = "direwolf";
    tag = finalAttrs.version;
    hash = "sha256-Vbxc6a6CK+wrBfs15dtjfRa1LJDKKyHMrg8tqsF7EX4=";
  };

  nativeBuildInputs = [
    cmake
    udevCheckHook
  ];

  strictDeps = true;

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      alsa-lib
      udev
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ portaudio ]
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

  postPatch =
    ''
      substituteInPlace conf/CMakeLists.txt \
        --replace-fail /etc/udev/rules.d/ ${placeholder "out"}/lib/udev/rules.d/
      substituteInPlace src/symbols.c \
        --replace-fail /usr/share/direwolf/symbols-new.txt ${placeholder "out"}/share/direwolf/symbols-new.txt \
        --replace-fail /opt/local/share/direwolf/symbols-new.txt ${placeholder "out"}/share/direwolf/symbols-new.txt
      substituteInPlace src/decode_aprs.c \
        --replace-fail /usr/share/direwolf/tocalls.txt ${placeholder "out"}/share/direwolf/tocalls.txt \
        --replace-fail /opt/local/share/direwolf/tocalls.txt ${placeholder "out"}/share/direwolf/tocalls.txt
      substituteInPlace cmake/cpack/direwolf.desktop.in \
        --replace-fail 'Terminal=false' 'Terminal=true' \
        --replace-fail 'Exec=@APPLICATION_DESKTOP_EXEC@' 'Exec=direwolf'
    ''
    + lib.optionalString extraScripts ''
      patchShebangs scripts/dwespeak.sh
      substituteInPlace scripts/dwespeak.sh \
        --replace-fail espeak ${espeak}/bin/espeak
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
