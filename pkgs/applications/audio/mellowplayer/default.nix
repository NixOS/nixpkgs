{ cmake
, fetchFromGitLab
, lib
, libnotify
, mkDerivation
, pkgconfig
, qtbase
, qtdeclarative
, qtgraphicaleffects
, qtquickcontrols2
, qttools
, qtwebengine
}:

mkDerivation rec {
  pname = "MellowPlayer";
  version = "3.6.5";

  src = fetchFromGitLab {
    owner = "ColinDuquesnoy";
    repo = "MellowPlayer";
    rev = version;
    sha256 = "1fnfqyy52hnh9vwq4rcndcqwh0zsm1sd3vi4h5gzaj4zbniq5v2f";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    libnotify
    qtbase
    qtdeclarative
    qtgraphicaleffects
    qtquickcontrols2
    qttools
    qtwebengine
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
  + (builtins.concatStringsSep "\n" (lib.lists.flatten (builtins.map
      (pkg: [
        (lib.optionalString (pkg ? qtPluginPrefix) ''
          export QT_PLUGIN_PATH="${pkg}/${pkg.qtPluginPrefix}"''${QT_PLUGIN_PATH:+':'}$QT_PLUGIN_PATH
        '')

        (lib.optionalString (pkg ? qtQmlPrefix) ''
          export QML2_IMPORT_PATH="${pkg}/${pkg.qtQmlPrefix}"''${QML2_IMPORT_PATH:+':'}$QML2_IMPORT_PATH
        '')
      ]) buildInputs)));

  meta = with lib; {
    inherit (qtbase.meta) platforms;

    description = "Cloud music integration for your desktop.";
    homepage = "https://gitlab.com/ColinDuquesnoy/MellowPlayer";
    license = licenses.gpl2;
    maintainers = with maintainers; [ kalbasit ];
  };
}
