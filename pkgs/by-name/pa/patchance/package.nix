{
  lib,
  fetchurl,
  python3Packages,
  libjack2,
  qt6,
  which,
  bash,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "patchance";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/Houston4444/Patchance/releases/download/v${finalAttrs.version}/Patchance-${finalAttrs.version}-source.tar.gz";
    hash = "sha256-U7/l+zz8T1cmEEYwr68N+J6G/K0rbJFmKUOveeVv7kw=";
  };

  pyproject = false;

  nativeBuildInputs = [
    python3Packages.pyqt6 # pyuic6 and pyrcc6 to build resources.
    qt6.qttools # lrelease to build translations.
    which # which to find lrelease.
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    libjack2
    bash
  ];
  propagatedBuildInputs = [
    python3Packages.pyqt6
    python3Packages.qtpy
    python3Packages.jack-client
  ];

  dontWrapQtApps = true; # The program is a python script.

  installFlags = [ "PREFIX=$(out)" ];

  makeWrapperArgs = [
    "--suffix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ libjack2 ])
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/patchance/src" "$out ''${pythonPath[*]}"
    for file in $out/bin/*; do
      wrapQtApp "$file"
    done
  '';

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'rcc -g python' '$(RCC) -g python'
  '';

  makeFlags = [
    "QT_VERSION=6"
    "QT_API=PyQt6"
    "RCC=${qt6.qtbase}/libexec/rcc"
  ];

  meta = {
    homepage = "https://github.com/Houston4444/Patchance";
    description = "JACK Patchbay GUI";
    mainProgram = "patchance";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
