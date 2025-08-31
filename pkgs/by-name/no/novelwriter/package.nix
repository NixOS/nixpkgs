{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  qt6,
  nix-update-script,
}:
let
  version = "2.7.4";
in
python3.pkgs.buildPythonApplication {
  pname = "novelwriter";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vkbo";
    repo = "novelWriter";
    rev = "v${version}";
    hash = "sha256-um8D5wqAe8KYQBG8XPKKS6iYnHsPLxSHpW710winDkY=";
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    pyqt6
    pyenchant
    qt6.qtbase
    qt6.qtwayland
  ];

  preBuild = ''
    export QT_QPA_PLATFORM_PLUGIN_PATH=${qt6.qtbase}/lib/qt-${qt6.qtbase.version}/plugins/platforms
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/{icons,applications,pixmaps,mime/packages}

    cp -r setup/data/hicolor $out/share/icons
    cp setup/data/novelwriter.desktop $out/share/applications
    cp setup/data/novelwriter.png $out/share/pixmaps
    cp setup/data/x-novelwriter-project.xml $out/share/mime/packages
  '';

  dontWrapQtApps = true;

  postFixup = ''
    wrapQtApp $out/bin/novelwriter
  '';

  passthru.updateScript = nix-update-script {
    # Stable releases only
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Open source plain text editor designed for writing novels";
    homepage = "https://novelwriter.io";
    changelog = "https://github.com/vkbo/novelWriter/blob/main/CHANGELOG.md";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "novelwriter";

    platforms = with lib.platforms; unix ++ windows;
    broken = stdenv.hostPlatform.isDarwin; # TODO awaiting build instructions for Darwin
  };
}
