{
  lib,
  fetchFromGitHub,
  fetchurl,
  wrapGAppsHook4,
  libadwaita,
  gobject-introspection,
  python3,
  python3Packages,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "android-tv-remote";
  version = "1.1.3";
  pyproject = true;


  src = fetchFromGitHub {
    owner = "erenseymen";
    repo = "android-tv-remote";
    rev = "v${version}";
    hash = "sha256-oGSDMGpOvIt1NFBx6g1dLtoCJBBQi+3Yl7g+XvIcRn8=";
  };

  scrcpy-server = fetchurl{
    url = "https://github.com/Genymobile/scrcpy/releases/download/v3.1/scrcpy-server-v3.1";
    hash = "sha256-lY8JRKYvI7HzOhbp6xSETBoEuILKF1pzjBbSPLIrhsA=";
  };

  postPatch = ''
    substituteInPlace src/gnome_adb_tv_remote/ui/ui_utils.py \
    --replace-fail 'return os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../data/icons/material"))' \
    'return "${placeholder "out"}/share/io.github.erenseymen.android-tv-remote/icons/material"'
    substituteInPlace src/gnome_adb_tv_remote/core/scrcpy_controller.py \
    --replace-fail 'Path("/app/share/scrcpy/scrcpy-server"),  # Flatpak' \
    'Path("${placeholder "out"}/share/scrcpy/scrcpy-server"),'
  '';

  buildInputs = [
    libadwaita
  ];

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  build-system = [
    python3Packages.setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    pyasn1
    rsa
    psutil
    adb-shell
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';


  postInstall = ''
    # Les icônes sont installées par setup.py dans un chemin que GTK n' parcourt pas.
    # On les recopie dans hicolor, le thème de fallback.
    mkdir -p $out/share/icons/hicolor/scalable/actions
    cp $out/share/io.github.erenseymen.android-tv-remote/icons/material/*.svg \
       $out/share/icons/hicolor/scalable/actions/
    install -Dm644 ${scrcpy-server} $out/share/scrcpy/scrcpy-server
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/tv-remote --help > /dev/null
  '';

  meta = with lib; {
    description = "A GTK-based remote control for Android TV devices";
    homepage = "https://github.com/erenseymen/android-tv-remote";
    maintainers = with maintainers; [ lethargii ];
    changelog = "https://github.com/erenseymen/android-tv-remote/releases";
    license = licenses.gpl3;
    mainProgram = "tv-remote";
    platforms = platforms.linux;
  };
}
