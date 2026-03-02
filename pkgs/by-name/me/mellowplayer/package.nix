{
  stdenv,
  cmake,
  fetchFromGitLab,
  lib,
  libnotify,
  pkg-config,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "MellowPlayer";
  version = "3.6.8";

  src = fetchFromGitLab {
    owner = "ColinDuquesnoy";
    repo = "MellowPlayer";
    tag = finalAttrs.version;
    hash = "sha256-rsF2xQet7U8d4oGU/HgghvE3vvmkxjlGXPBlLD9mWTk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libnotify
    libsForQt5.qtbase
    libsForQt5.qtdeclarative
    libsForQt5.qtgraphicaleffects
    libsForQt5.qtquickcontrols2
    libsForQt5.qttools
    libsForQt5.qtwebengine
  ];

  doCheck = true;

  cmakeFlags = [ "-DBUILD_TESTS=ON" ];

  preCheck = ''
    # Running the tests requires a location at the home directory for logging.
    export HOME="$NIX_BUILD_TOP/home"
    mkdir -p "$HOME/.local/share/MellowPlayer.Tests/MellowPlayer.Tests/Logs"

    # Without this, the tests fail because they cannot create the QT Window
    export QT_QPA_PLATFORM=offscreen
  ''
  # TODO: The tests are failing because it can't locate QT plugins. Is there a better way to do this?
  + (builtins.concatStringsSep "\n" (
    lib.lists.flatten (
      map (pkg: [
        (lib.optionalString (pkg ? qtPluginPrefix) ''
          export QT_PLUGIN_PATH="${pkg}/${pkg.qtPluginPrefix}"''${QT_PLUGIN_PATH:+':'}$QT_PLUGIN_PATH
        '')

        (lib.optionalString (pkg ? qtQmlPrefix) ''
          export QML2_IMPORT_PATH="${pkg}/${pkg.qtQmlPrefix}"''${QML2_IMPORT_PATH:+':'}$QML2_IMPORT_PATH
        '')
      ]) finalAttrs.buildInputs
    )
  ));

  meta = {
    inherit (libsForQt5.qtbase.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin; # test build fails, but the project is not maintained anymore

    description = "Cloud music integration for your desktop";
    mainProgram = "MellowPlayer";
    homepage = "https://gitlab.com/ColinDuquesnoy/MellowPlayer";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
})
