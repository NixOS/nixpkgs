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
  version = "0.0.22-unstable-2026-08-28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "johnfanv2";
    repo = "LenovoLegionLinux";
    rev = "3893e203332d60effea688a3043abd86046997ad";
    hash = "sha256-e/h/n4cYw/T+6iroF0SD564MNbi6aX+usVp0+e5LNak=";
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
