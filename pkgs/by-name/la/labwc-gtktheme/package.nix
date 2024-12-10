{
  lib,
  fetchFromGitHub,
  gobject-introspection,
  gtk3,
  python3Packages,
  wrapGAppsHook3,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "labwc-gtktheme";
  version = "0-unstable-2022-07-17";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-gtktheme";
    rev = "0eb103701775ecd3aa4d517f42dede4f56381241";
    hash = "sha256-aeF6unzR9bqaKXkqOHlGrMdPx3xXCtig58tKVliUO4g=";
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
    maintainers = with lib.maintainers; [
      AndersonTorres
      romildo
    ];
  };
}
