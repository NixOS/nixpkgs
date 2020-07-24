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
  version = "3.6.4";

  src = fetchFromGitLab {
    owner = "ColinDuquesnoy";
    repo = "MellowPlayer";
    rev = version;
    sha256 = "1ss7s3kal4vzhz7ld0yy2kvp1rk2w3i6fya0z3xd7nff9p31gqvw";
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
