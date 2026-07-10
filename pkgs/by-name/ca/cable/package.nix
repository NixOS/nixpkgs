{
  lib,
  python3,
  fetchFromGitHub,
  qt6,
  hicolor-icon-theme,
  pipewire,
  wireplumber,
  pulseaudio,
  aj-snapshot,
  jack-example-tools,
  graphviz,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "cable";
  version = "0.10.9";

  src = fetchFromGitHub {
    owner = "magillos";
    repo = "Cable";
    rev = finalAttrs.version;
    hash = "sha256-o5OsJ2mOUr+51C0oB3owKXDr9qvG+D7L07j6cGhrS1o=";
  };

  pyproject = true;
  nativeBuildInputs = [
    python3.pkgs.setuptools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtsvg
  ];

  propagatedBuildInputs = [
    python3.pkgs.dbus-python
    python3.pkgs.pyqt6
    python3.pkgs.requests
    python3.pkgs.packaging
    python3.pkgs.pyalsaaudio
    python3.pkgs.graphviz
    python3.pkgs.jack-client
  ];

  dontWrapQtApps = true;

  # Full transitive closure is required: the child process launched via
  # QProcess(sys.executable, …) inherits PYTHONPATH but not the wrapper's
  # site.addsitedir() calls, so transitive deps must be explicit.
  postFixup =
    let
      inherit (python3) sitePackages;
      allPythonDeps = python3.pkgs.requiredPythonModules finalAttrs.propagatedBuildInputs;
      pythonpath = lib.concatMapStringsSep ":" (pkg: "${pkg}/${sitePackages}") allPythonDeps;
      runtimePath = lib.makeBinPath [
        pipewire
        wireplumber
        pulseaudio
        aj-snapshot
        jack-example-tools
        graphviz
      ];
    in
    ''
      wrapQtApp "$out/bin/cable" \
        --prefix PATH : "${runtimePath}" \
        --set PYTHONPATH "$out/${sitePackages}:${pythonpath}"
    '';

  postInstall = ''
    # process.py spawns connection-manager.py via QProcess(sys.executable, …),
    # bypassing the Nix wrapper. Place it in site-packages so the relative
    # path lookup in process.py resolves correctly at runtime.
    cp $src/connection-manager.py \
       $out/${python3.sitePackages}/connection-manager.py

    mkdir -p $out/share/icons/hicolor/scalable/apps
    cp $src/*.svg $out/share/icons/hicolor/scalable/apps
    # index.theme is required for Qt to recognise this as a valid icon search path.
    cp ${hicolor-icon-theme}/share/icons/hicolor/index.theme \
       $out/share/icons/hicolor/index.theme

    install -Dm644 $src/com.github.magillos.cable.desktop \
      $out/share/applications/com.github.magillos.cable.desktop
  '';

  meta = {
    description = "GUI to dynamically modify PipeWire and WirePlumber settings at runtime";
    homepage = "https://github.com/magillos/Cable";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ DimseBoms ];
    mainProgram = "cable";
    platforms = lib.platforms.linux;
  };
})
