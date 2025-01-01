{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  qt5,
  nix-update-script,
}:
let
  version = "2.5.2";
in
python3.pkgs.buildPythonApplication {
  pname = "novelwriter";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vkbo";
    repo = "novelWriter";
    rev = "v${version}";
    hash = "sha256-xRSq6lBZ6jHtNve027uF2uNs3/40s0YdFN9F9O7m5VU=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    pyqt5
    pyenchant
    qt5.qtbase
    qt5.qtwayland
  ];

  preBuild = ''
    export QT_QPA_PLATFORM_PLUGIN_PATH=${qt5.qtbase.bin}/lib/qt-${qt5.qtbase.version}/plugins/platforms
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
