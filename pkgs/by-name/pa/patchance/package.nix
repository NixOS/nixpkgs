{
  lib,
  fetchurl,
  python3,
  qt6,
  bash,
}:

let
  # Executable dependencies
  exe = {
    bash = lib.getExe bash;
    python3 = lib.getExe python3;
    lrelease = lib.getExe' qt6.qttools "lrelease";
    rcc = "${qt6.qtbase}/libexec/rcc";
  };
in

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "patchance";
  version = "1.4.0";

  src = fetchurl {
    url = "https://github.com/Houston4444/Patchance/releases/download/v${finalAttrs.version}/Patchance-${finalAttrs.version}-source.tar.gz";
    hash = "sha256-U7/l+zz8T1cmEEYwr68N+J6G/K0rbJFmKUOveeVv7kw=";
  };

  pyproject = false;

  nativeBuildInputs = [
    python3.pkgs.pyqt6 # “pyuic6” executable
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtsvg
  ];

  propagatedBuildInputs = [
    python3.pkgs.pyqt6
    python3.pkgs.qtpy
    python3.pkgs.jack-client
  ];

  dontWrapQtApps = true; # The program is a python script.

  installFlags = [ "PREFIX=$(out)" ];

  makeFlags = [
    "QT_VERSION=6"
    "QT_API=PyQt6"
    "PYUIC=pyuic6"
    "SHELL=${exe.bash}"
    "RCC=${exe.rcc}"
    "LRELEASE=${exe.lrelease}"
  ];

  postPatch = ''
    # Fix paths in Makefile and avoid invoking “which”.
    #
    # Note that `rcc -g python` thing seems to be already fixed in `master`
    # but not in the latest stable 1.4.0 release.
    # See https://github.com/Houston4444/Patchance/blob/v1.4.0/Makefile#L85C2-L85C15
    # and https://github.com/Houston4444/Patchance/commit/1986cc5
    # TODO: Remove it for the next version update when it releases.
    substituteInPlace Makefile \
      --replace-fail '$(shell which $(PYTHON))' ${lib.escapeShellArg exe.python3} \
      --replace-fail '$(shell which $(LRELEASE))' ${lib.escapeShellArg exe.lrelease} \
      --replace-fail '$(shell which $(RCC))' ${lib.escapeShellArg exe.rcc} \
      --replace-fail 'rcc -g python' ${lib.escapeShellArg "${exe.rcc} -g python"}
    substituteInPlace HoustonPatchbay/Makefile \
      --replace-fail '$(shell which $(LRELEASE))' ${lib.escapeShellArg exe.lrelease}

    # Fix a Python syntax bug.
    # See https://github.com/Houston4444/HoustonPatchbay/issues/27
    substituteInPlace HoustonPatchbay/source/patch_engine/patch_engine.py \
      --replace-fail \
        '"JACK seems to be compiled without Metadatas support, ",' \
        '"JACK seems to be compiled without Metadatas support, "'
  '';

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/share/patchance/src" "$out ''${pythonPath[*]}"
    for file in $out/bin/*; do
      wrapQtApp "$file"
    done
  '';

  meta = {
    homepage = "https://github.com/Houston4444/Patchance";
    description = "JACK Patchbay GUI";
    mainProgram = "patchance";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.unclechu ];
    platforms = lib.platforms.linux;
  };
})
