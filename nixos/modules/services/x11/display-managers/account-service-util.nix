{ accountsservice
, glib
, gobject-introspection
, python3
, wrapGAppsNoGuiHook
, lib
, mypy
}:

python3.pkgs.buildPythonApplication {
  name = "set-session";

  format = "other";

  src = ./set-session.py;

  dontUnpack = true;

  strictDeps = false;

  nativeBuildInputs = [
    wrapGAppsNoGuiHook
    gobject-introspection
  ];

  buildInputs = [
    accountsservice
    glib
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    ordered-set
  ];

  checkInputs = [
    mypy
  ];

  installPhase = ''
    install -m755 -D $src $out/bin/set-session
  '';

  checkPhase = ''
    mypy --ignore-missing-imports $src
  '';

  meta = with lib; {
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
  };
}
