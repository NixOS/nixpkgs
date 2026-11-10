{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  cmake,
  nix-update-script,
  pkg-config,
  qt6,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  xxd,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "doomseeker";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "DoomseekerTeam";
    repo = "Doomseeker";
    tag = finalAttrs.version;
    hash = "sha256-oTWsGLtXqate1UuVM47mlPOqIVYLOHEp8utR07sOoE4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    ./dont_update_gitinfo.patch
    ./add_gitinfo.patch
    ./fix_paths.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
    xxd
  ];

  buildInputs = [
    bzip2
    qt6.qtbase
    qt6.qtmultimedia
    zlib
  ];

  cmakeFlags = [ (lib.cmakeFeature "Qt_PACKAGE" "Qt6") ];

  # Doomseeker looks for the engines in the program directory
  postInstall = ''
    mv $out/bin/* $out/lib/doomseeker/
    ln -s $out/lib/doomseeker/doomseeker $out/bin/
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  hardeningDisable = lib.optional stdenv.hostPlatform.isDarwin "format";

  preInstallCheck = ''
    export QT_QPA_PLATFORM=offscreen
  '';

  versionCheckKeepEnvironment = "HOME QT_QPA_PLATFORM";
  versionCheckProgramArg = "--version-json";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multiplayer server browser for many Doom source ports";
    homepage = "https://doomseeker.drdteam.org/";
    changelog = "https://github.com/DoomseekerTeam/Doomseeker/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.unix;
    mainProgram = "doomseeker";
    # The last successful Darwin Hydra build was in 2023
    broken = stdenv.hostPlatform.isDarwin;
  };
})
