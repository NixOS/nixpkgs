{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  python3Packages,
  wrapGAppsHook3,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication {
  pname = "labwc-gtktheme";
  version = "0-unstable-2025-02-11";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-gtktheme";
    rev = "619fa316702a6c21a0d974d7cf3dde0b82f9f64b";
    hash = "sha256-mhpN8H42dJwc+3os3I48mmAWQJQCrO4yjbuMPTmHbsI=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  pythonPath = with python3Packages; [
    pygobject3
  ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -a labwc-gtktheme.py $out/bin/labwc-gtktheme
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/labwc/labwc-gtktheme";
    description = "Create a labwc theme based on current Gtk theme";
    mainProgram = "labwc-gtktheme";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
