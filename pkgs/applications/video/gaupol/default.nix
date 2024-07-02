{ lib
, python39
, fetchFromGitHub
, gnome
, gobject-introspection
, gtk3
, bash
, cairo
, glibcLocales
, wrapGAppsHook
}:

let
  python = python39;
in python.pkgs.buildPythonApplication rec {
  pname = "gaupol";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "otsaloma";
    repo = "gaupol";
    rev = version;
    hash = "sha256-iF2ScQFYxYM2o18Cfy6U6JAZxIiZSsGrWEb4yjyECwc=";
  };

  propagatedBuildInputs = with python.pkgs; [
    cairo
    gobject-introspection
    gtk3
    pygobject3
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gnome.adwaita-icon-theme
  ];

  checkInputs = [
    glibcLocales
  ];

  nativeCheckInputs = with python.pkgs; [
    flake8
  ];


  checkPhase = ''
    make check
  '';


  postInstall = ''
    # Causes fatal ldconfig cache generation attempt on non-NixOS Linux
    for mkfile in $out/lib/python3.9/site-packages/aeidon/paths.py ; do
      substituteInPlace $mkfile \
        --replace '/gaupol-1.11.data/data/share' $out/share
    done
  '';


  meta = with lib; {
    homepage = "https://github.com/otsaloma/gaupol";
    description = "Editor for text-based subtitle files";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
