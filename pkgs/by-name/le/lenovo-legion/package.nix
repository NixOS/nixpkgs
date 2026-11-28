{
  lib,
  fetchFromGitHub,
  libxcb,
  python3,
  nix-update-script,
  qt6,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lenovo-legion-app";
  version = "0.1.8-unstable-2026-11-17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "johnfanv2";
    repo = "LenovoLegionLinux";
    rev = "98531565555d43c2e34c2c487ffcbba273c5e803";
    hash = "sha256-cKtwIC9BsDqFAQ1YRTGrr88F6JHB75GTbttCZG+r+Hs=";
  };

  sourceRoot = "${src.name}/python/legion_linux";

  build-system = with python3.pkgs; [
    setuptools
    qt6.wrapQtAppsHook
  ];

  dependencies = with python3.pkgs; [
    pyqt6
    qt6.qtbase
    argcomplete
    pillow
    pyyaml
    darkdetect
    libxcb
  ];

  postPatch = ''
    # only fixup application (legion-linux-gui), service (legiond) currently not installed so do not fixup
    # /etc
    substituteInPlace ./legion_linux/legion.py \
      --replace-fail "/etc/legion_linux" "$out/share/legion_linux"

    # /usr
    substituteInPlace ./legion_linux/legion_gui.desktop \
      --replace-fail "Icon=/usr/share/pixmaps/legion_logo.png" "Icon=legion_logo"
  '';

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Utility to control Lenovo Legion laptop";
    homepage = "https://github.com/johnfanv2/LenovoLegionLinux";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      ulrikstrid
      logger
      chn
    ];
    mainProgram = "legion_gui";
  };
}
