{
  lib,
  fetchFromGitHub,
  fsuae,
  gettext,
  python3Packages,
  stdenv,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fs-uae-launcher";
  version = "3.2.35";

  src = fetchFromGitHub {
    owner = "FrodeSolheim";
    repo = "fs-uae-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ggzius1jVtjWerzBpY5oLcPqymN9IVDCwQz+bW9igGg=";
  };

  nativeBuildInputs = [
    gettext
    kdePackages.qtbase
    kdePackages.wrapQtAppsHook
    python3Packages.python
    python3Packages.pyopengl
  ];

  buildInputs = with python3Packages; [
    pyqt6
    requests
    setuptools
  ];

  strictDeps = true;

  makeFlags = [ "prefix=$(out)" ];

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "distutils.core" "setuptools"
  '';

  preFixup = ''
    wrapQtApp "$out/bin/fs-uae-launcher" \
      --set PYTHONPATH "$PYTHONPATH"

    # fs-uae-launcher search side by side for executables and shared files
    # see $src/fsgs/plugins/pluginexecutablefinder.py#find_executable
    ln -s ${fsuae}/bin/fs-uae $out/bin
    ln -s ${fsuae}/bin/fs-uae-device-helper $out/bin
    ln -s ${fsuae}/share/fs-uae $out/share/fs-uae
  '';

  meta = {
    homepage = "https://fs-uae.net";
    description = "Graphical front-end for the FS-UAE emulator";
    license = lib.licenses.gpl2Plus;
    mainProgram = "fs-uae-launcher";
    platforms = with lib.systems.inspect; patternLogicalAnd patterns.isx86 patterns.isLinux;
  };
})
