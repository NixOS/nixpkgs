{
  lib,
  fetchFromGitLab,
  python3Packages,
  gobject-introspection,
  gsettings-desktop-schemas,
  gtk3,
  wrapGAppsHook3,
  xrandr,
  nix-update-script,
}:

let
  inherit (python3Packages)
    buildPythonApplication
    setuptools
    docutils
    pygobject3
    ;
in
buildPythonApplication rec {
  pname = "arandr";
  version = "0.1.11";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "arandr";
    repo = "arandr";
    tag = version;
    hash = "sha256-nQtfOKAnWKsy2DmvtRGJa4+Y9uGgX41BeHpd9m4d9YA=";
  };

  # patch to set mtime=0 on setup.py
  patches = [ ./gzip-timestamp-fix.patch ];
  patchFlags = [ "-p0" ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gsettings-desktop-schemas
    gtk3
    xrandr
  ];

  build-system = [ setuptools ];

  dependencies = [
    docutils
    pygobject3
  ];

  preBuild = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=(\\d.*)"
    ];
  };

  meta = {
    changelog = "https://gitlab.com/arandr/arandr/-/blob/${src.tag}/ChangeLog";
    description = "Simple visual front end for XRandR";
    homepage = "https://christian.amsuess.com/tools/arandr/";
    license = lib.licenses.gpl3;
    mainProgram = "arandr";
    maintainers = with lib.maintainers; [
      gepbird
    ];
  };
}
