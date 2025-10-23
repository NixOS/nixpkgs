{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  qt6,
  nix-update-script,
}:
let
  version = "2.7.5";
in
python3.pkgs.buildPythonApplication {
  pname = "novelwriter";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vkbo";
    repo = "novelWriter";
    tag = "v${version}";
    hash = "sha256-qCbtQwV+dU/ypnb5UruTsXas9XUqlJweaxnfqTHsT+I=";
  };

  nativeBuildInputs = [ qt6.wrapQtAppsHook ];
  buildInputs = [ qt6.qtbase ];

  build-system = with python3.pkgs; [ setuptools ];
  dependencies = with python3.pkgs; [
    pyqt6
    pyenchant
    qt6.qtsvg
  ];

  # See setup/debian/install
  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/icons
    cp -r setup/data/hicolor $out/share/icons

    install -Dm644 setup/data/novelwriter.png -t $out/share/pixmaps
    install -Dm644 setup/data/novelwriter.desktop -t $out/share/applications
    install -Dm644 setup/data/x-novelwriter-project.xml -t $out/share/mime/packages
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
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "novelwriter";

    platforms = with lib.platforms; unix ++ windows;
    broken = stdenv.hostPlatform.isDarwin; # TODO awaiting build instructions for Darwin
  };
}
