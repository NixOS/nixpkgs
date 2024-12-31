{
  lib,
  python3Packages,
  fetchFromGitHub,
  glibc,
  SDL2,
  libjpeg_turbo,
  alsa-lib,
  libspnav,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook3,
  wrapGAppsHook4,
  cameractrls-gtk3,
  cameractrls-gtk4,
  withGtk ? null,
}:

assert lib.assertOneOf "'withGtk' in cameractrls" withGtk [
  3
  4
  null
];

let
  mainExecutable =
    "cameractrls" + lib.optionalString (withGtk != null) "gtk" + lib.optionalString (withGtk == 4) "4";

  modulePath = "${placeholder "out"}/${python3Packages.python.sitePackages}/CameraCtrls";

  installExecutables = [
    "cameractrls"
    "cameractrlsd"
    "cameraptzgame"
    "cameraptzmidi"
    "cameraptzspnav"
    "cameraview"
  ] ++ lib.optionals (withGtk != null) [ mainExecutable ];
in
python3Packages.buildPythonApplication rec {
  pname = "cameractrls";
  version = "0.6.6";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "soyersoyer";
    repo = "cameractrls";
    rev = "v${version}";
    hash = "sha256-QjjLd5L+8Slxc3ywurhsWp1pZ2E1Y7NOdnCV2ZYBlqU=";
  };

  postPatch = ''
    substituteInPlace cameractrlsd.py \
      --replace-fail "ctypes.util.find_library('c')" '"${lib.getLib glibc}/lib/libc.so.6"'
    substituteInPlace cameraptzgame.py cameraview.py \
      --replace-fail "ctypes.util.find_library('SDL2-2.0')" '"${lib.getLib SDL2}/lib/libSDL2-2.0.so.0"'
    substituteInPlace cameraview.py \
      --replace-fail "ctypes.util.find_library('turbojpeg')" '"${lib.getLib libjpeg_turbo}/lib/libturbojpeg.so"'
    substituteInPlace cameraptzmidi.py \
      --replace-fail "ctypes.util.find_library('asound')" '"${lib.getLib alsa-lib}/lib/libasound.so"'
    substituteInPlace cameraptzspnav.py \
      --replace-fail "ctypes.util.find_library('spnav')" '"${lib.getLib libspnav}/lib/libspnav.so"'
  '';

  nativeBuildInputs =
    lib.optionals (withGtk != null) [
      desktop-file-utils
      gobject-introspection
    ]
    ++ lib.optionals (withGtk == 3) [ wrapGAppsHook3 ]
    ++ lib.optionals (withGtk == 4) [ wrapGAppsHook4 ];

  # Only used when withGtk != null
  dependencies = with python3Packages; [ pygobject3 ];

  installPhase =
    ''
      runHook preInstall

      mkdir -p $out/bin

      for file in ${lib.concatStringsSep " " installExecutables}; do
        install -Dm755 $file.py -t ${modulePath}
        ln -s ${modulePath}/$file.py $out/bin/$file
      done
    ''
    + lib.optionalString (withGtk != null) ''
      install -Dm644 pkg/hu.irl.cameractrls.svg -t $out/share/icons/hicolor/scalable/apps
      install -Dm644 pkg/hu.irl.cameractrls.metainfo.xml -t $out/share/metainfo
      mkdir -p $out/share/applications
      desktop-file-install \
        --dir="$out/share/applications" \
        --set-key=Exec --set-value="${mainExecutable}" \
        pkg/hu.irl.cameractrls.desktop
    ''
    + ''
      runHook postInstall
    '';

  dontWrapGApps = true;
  dontWrapPythonPrograms = true;

  postFixup = lib.optionalString (withGtk != null) ''
    wrapPythonPrograms
    patchPythonScript ${modulePath}/${mainExecutable}.py
    wrapProgram $out/bin/${mainExecutable} ''${makeWrapperArgs[@]} ''${gappsWrapperArgs[@]}
  '';

  passthru.tests = {
    # Also build these packages in ofBorg (defined in top-level/all-packages.nix)
    inherit cameractrls-gtk3 cameractrls-gtk4;
  };

  meta = {
    description = "Camera controls for Linux";
    longDescription = ''
      It's a standalone Python CLI and GUI (GTK3, GTK4) and
      camera Viewer (SDL) to set the camera controls in Linux.
      It can set the V4L2 controls and it is extendable with
      the non standard controls. Currently it has a Logitech
      extension (LED mode, LED frequency, BRIO FoV, Relative
      Pan/Tilt, PTZ presets), Kiyo Pro extension (HDR, HDR
      mode, FoV, AF mode, Save), Preset extension (Save and
      restore controls), Control Restore Daemon (to restore
      presets at device connection).
    '';
    homepage = "https://github.com/soyersoyer/cameractrls";
    license = lib.licenses.gpl3Plus;
    mainProgram = mainExecutable;
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.linux;
  };
}
