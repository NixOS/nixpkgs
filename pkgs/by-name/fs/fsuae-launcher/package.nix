{
  lib,
  fetchFromGitHub,
  fsuae,
  gettext,
  python3Packages,
  stdenv,
  libsForQt5,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fs-uae-launcher";
  version = "3.2.20";

  src = fetchFromGitHub {
    owner = "FrodeSolheim";
    repo = "fs-uae-launcher";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JuCwcVKuc0EzsKQiPXobH9tiIWEFD3tjcXneRXzjsH0=";
  };

  nativeBuildInputs = [
    gettext
    python3Packages.python
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = with python3Packages; [
    pyqt5
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

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://fs-uae.net";
    description = "Graphical front-end for the FS-UAE emulator";
    license = lib.licenses.gpl2Plus;
    mainProgram = "fs-uae-launcher";
    maintainers = with lib.maintainers; [
      sander
      c4patino
    ];
    platforms = with lib.systems.inspect; patternLogicalAnd patterns.isx86 patterns.isLinux;
  };
})
