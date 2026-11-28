{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  nix-update-script,
  glib,
  gettext,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plasma-smart-video-wallpaper-reborn";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "luisbocanegra";
    repo = "plasma-smart-video-wallpaper-reborn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ACMu7/5IrF4+uLyE7AbIlicUWTuKpZAVz9B2VwXnxl0=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    gettext
  ];

  buildInputs = [
    bash
    kdePackages.libplasma
    kdePackages.ki18n
    kdePackages.kcmutils
    kdePackages.knighttime
    kdePackages.qtdeclarative
  ];

  strictDeps = true;
  __structuredAttrs = true;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PLUGIN" true)
    (lib.cmakeBool "INSTALL_WALLPAPER" true)
  ];

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace package/contents/ui/tools/gdbus_get_signal.sh \
      --replace-fail 'gdbus monitor' '${lib.getExe' glib "gdbus"} monitor'
    substituteInPlace package/contents/ui/DBusFallback.qml \
      --replace-fail '"gdbus call' '"${lib.getExe' glib "gdbus"} call'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plasma 6 wallpaper plugin to play videos on your Desktop/Lock Screen";
    homepage = "https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn";
    changelog = "https://github.com/luisbocanegra/plasma-smart-video-wallpaper-reborn/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ hsidhu1332 ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
