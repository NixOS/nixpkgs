{
  lib,
  stdenv,

  writeShellScriptBin,
  xdg-utils,

  fetchFromCodeberg,

  cmake,
  ninja,
  kdePackages,
  qt6,

  libpwquality,
  libxcrypt,
  parted,
  yaml-cpp,

  tzdata,
  ckbcomp,
  util-linux,
  os-prober,
  xkeyboard_config,

  extraWrapperArgs ? [ ],

  # passthru.tests
  calamares-nixos,
}:

let
  # drop privileges so we can launch browsers, etc;
  # force going through the portal so we get the right environment
  xdg-open-nixos = writeShellScriptBin "xdg-open" ''
    sudo --user $(id -nu $PKEXEC_UID) env NIXOS_XDG_OPEN_USE_PORTAL=1 ${xdg-utils}/bin/xdg-open "$@"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "calamares";
  version = "3.4.2";

  src = fetchFromCodeberg {
    owner = "Calamares";
    repo = "calamares";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/foh3NKXTaNmP+x18t+GeAz7qv4e/TyspSEln8mMH4I=";
  };

  patches = [
    # Don't allow LUKS in manual partitioning
    # FIXME: this really needs to be fixed on the module end
    ./dont-allow-manual-luks.patch

    # Don't create users - they're already created by the installer
    # FIXME: upstream this?
    ./dont-create-users.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kcoreaddons
    kdePackages.kcrash
    kdePackages.kpackage
    kdePackages.kparts
    kdePackages.kpmcore
    kdePackages.kservice
    kdePackages.libplasma
    libpwquality
    libxcrypt
    parted
    kdePackages.polkit-qt-1
    qt6.qtbase
    qt6.qttools
    yaml-cpp
  ];

  postPatch = ''
    substituteInPlace io.calamares.calamares.policy \
      --replace-fail /usr/bin/calamares $out/bin/calamares

    substituteInPlace src/modules/locale/SetTimezoneJob.cpp src/libcalamares/locale/TimeZone.cpp \
      --replace-fail /usr/share/zoneinfo ${tzdata}/share/zoneinfo

    substituteInPlace src/modules/keyboard/keyboardwidget/keyboardglobal.cpp \
      --replace-fail /usr/share/X11/xkb/rules/base.lst ${xkeyboard_config}/share/X11/xkb/rules/base.lst

    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}" "$out/share/polkit-1/actions"
  '';

  separateDebugInfo = true;

  qtWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        ckbcomp
        os-prober
        util-linux
        xdg-open-nixos
      ]
    }"
  ]
  ++ extraWrapperArgs;

  passthru.tests = {
    inherit calamares-nixos;
  };

  meta = {
    description = "Distribution-independent installer framework";
    homepage = "https://calamares.io/";
    license = with lib.licenses; [
      gpl3Plus
      bsd2
      cc0
    ];
    maintainers = with lib.maintainers; [
      vlinkz
    ];
    platforms = lib.platforms.linux;
    mainProgram = "calamares";
  };
})
