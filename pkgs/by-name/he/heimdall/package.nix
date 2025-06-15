{
  cmake,
  enableGUI ? false,
  fetchFromSourcehut,
  gitUpdater,
  lib,
  libusb1,
  pkg-config,
  qt6,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "heimdall";
  version = "2.2.1";

  src = fetchFromSourcehut {
    owner = "~grimler";
    repo = "Heimdall";
    rev = "v${finalAttrs.version}";
    hash = "sha256-x+mDTT+oUJ4ffZOmn+UDk3+YE5IevXM8jSxLKhGxXSM=";
  };

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  patches = [
    ./0001-Install-the-macOS-bundle-to-the-install-prefix.patch
  ];

  outputs = [
    "out"
    "udev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optional enableGUI qt6.wrapQtAppsHook;

  buildInputs = [
    (libusb1.override { withStatic = stdenv.hostPlatform.isWindows; })
  ] ++ lib.optional enableGUI qt6.qtbase;

  preInstall = ''
    mkdir -p $udev/lib/udev/rules.d
    install -m644 -t $udev/lib/udev/rules.d $src/heimdall/60-heimdall.rules
  '';

  # heimdall cli looked up from PATH by gui
  preFixup = lib.optional enableGUI ''
    qtWrapperArgs+=(--prefix PATH : "$out/bin")
  '';

  cmakeFlags = [
    (lib.cmakeBool "DISABLE_FRONTEND" (!enableGUI))
  ];

  meta = {
    description = "Cross-platform open-source tool suite used to flash firmware onto Samsung Galaxy devices";
    homepage = "https://git.sr.ht/~grimler/Heimdall";
    license = lib.licenses.mit;
    mainProgram =
      (if enableGUI then "heimdall-frontend" else "heimdall")
      + lib.optionalString stdenv.hostPlatform.isWindows ".exe";
    maintainers = with lib.maintainers; [
      surfaceflinger
    ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
