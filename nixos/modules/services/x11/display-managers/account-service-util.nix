{
  accountsservice,
  glib,
  gobject-introspection,
  python3,
  wrapGAppsNoGuiHook,
  lib,
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

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/set-session
    chmod +x $out/bin/set-session
  '';

  meta = with lib; {
    maintainers = with maintainers; [ ] ++ teams.pantheon.members;
  };
}
