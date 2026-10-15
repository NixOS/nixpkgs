{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "osmic";
  version = "0.2-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "gmgeo";
    repo = "osmic";
    rev = "94b418619c72fd2caa0edfa08c7a959ac3f48b2a";
    hash = "sha256-ipss5d9VL9GVGAb2pS05BzEoti05expnzHdnaO957+g=";
  };

  nativeBuildInputs = [ python3.pkgs.wrapPython ];

  pythonPath = with python3.pkgs; [
    lxml
    pyyaml
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    for category in */; do
      # font/ holds the icon font, which is SIL OFL rather than CC0, and tools/ the export scripts.
      case $category in
        font/ | tools/) continue ;;
      esac
      install -Dm444 -t "$out/share/osmic/icons/''${category%/}" "$category"*.svg
    done

    # The repository holds only the source icons; upstream generates every
    # derivative collection (padded, recoloured, filtered, sprites) with this
    # script, driven by a YAML config. See tools/export.md for the format.
    install -Dm755 tools/export.py "$out/bin/osmic-export"

    runHook postInstall
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Clean high quality SVG map icons for OpenStreetMap";
    homepage = "https://github.com/gmgeo/osmic";
    license = lib.licenses.cc0;
    mainProgram = "osmic-export";
    maintainers = with lib.maintainers; [ LorenzBischof ];
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.all;
  };
}
