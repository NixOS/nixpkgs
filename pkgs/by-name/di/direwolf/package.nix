{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Fix the build with CMake 4.
    (fetchpatch {
      url = "https://github.com/wb2osz/direwolf/commit/c499496bbc237d0efdcacec5786607f5e17c1c7e.patch";
      hash = "sha256-/gKi5dswMQM2nGHS3P72gAcHaT0nEF9O91heF8xmy2Y=";
    })
  ];

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

  preConfigure = lib.optionals (!extraScripts) ''
    echo "" > scripts/CMakeLists.txt
  '';

  postPatch = ''
    substituteInPlace conf/CMakeLists.txt \
      --replace-fail /etc/udev/rules.d/ $out/lib/udev/rules.d/
    substituteInPlace src/symbols.c \
      --replace-fail /usr/share/direwolf/symbols-new.txt $out/share/direwolf/symbols-new.txt \
      --replace-fail /opt/local/share/direwolf/symbols-new.txt $out/share/direwolf/symbols-new.txt
    substituteInPlace src/decode_aprs.c \
      --replace-fail /usr/share/direwolf/tocalls.txt $out/share/direwolf/tocalls.txt \
      --replace-fail /opt/local/share/direwolf/tocalls.txt $out/share/direwolf/tocalls.txt
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
