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
<<<<<<< HEAD
  inherit (python3Packages)
    buildPythonApplication
    setuptools
    docutils
    pygobject3
    ;
=======
  inherit (python3Packages) buildPythonApplication docutils pygobject3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
buildPythonApplication rec {
  pname = "arandr";
  version = "0.1.11";
<<<<<<< HEAD
  pyproject = true;
=======
  format = "setuptools";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    gsettings-desktop-schemas
    gtk3
    xrandr
  ];

  build-system = [ setuptools ];

  dependencies = [
    docutils
=======
    docutils
    gsettings-desktop-schemas
    gtk3
  ];

  propagatedBuildInputs = [
    xrandr
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pygobject3
  ];

  preBuild = ''
    rm -rf data/po/*
  '';

  # no tests
  doCheck = false;

<<<<<<< HEAD
  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=(\\d.*)"
    ];
  };

  meta = {
    changelog = "https://gitlab.com/arandr/arandr/-/blob/${src.tag}/ChangeLog";
    description = "Simple visual front end for XRandR";
    homepage = "https://christian.amsuess.com/tools/arandr/";
<<<<<<< HEAD
    license = lib.licenses.gpl3Plus;
=======
    license = lib.licenses.gpl3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "arandr";
    maintainers = with lib.maintainers; [
      gepbird
    ];
  };
}
