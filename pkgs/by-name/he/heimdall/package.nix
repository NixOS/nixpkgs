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

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optional enableGUI qt6.wrapQtAppsHook;

  buildInputs = [
    (libusb1.override { withStatic = stdenv.hostPlatform.isWindows; })
  ] ++ lib.optional enableGUI qt6.qtbase;

  postFixup = lib.optional enableGUI ''
    # heimdall cli looked up from PATH by gui
    wrapProgram $out/bin/heimdall-frontend \
      --prefix PATH : $out/bin
  '';

  cmakeFlags = [
    "-DDISABLE_FRONTEND=${if enableGUI then "OFF" else "ON"}"
  ];

  meta = {
    broken = enableGUI && !stdenv.hostPlatform.isLinux;
    description = "Cross-platform open-source tool suite used to flash firmware onto Samsung mobile devices";
    homepage = "https://git.sr.ht/~grimler/Heimdall";
    license = lib.licenses.mit;
    mainProgram = if enableGUI then "heimdall-frontend" else "heimdall";
    maintainers = with lib.maintainers; [
      peterhoeg
      surfaceflinger
    ];
    platforms = with lib.platforms; unix ++ windows;
  };
})
