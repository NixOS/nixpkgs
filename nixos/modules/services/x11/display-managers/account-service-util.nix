{ accountsservice
, glib
, gobject-introspection
, python3
<<<<<<< HEAD
, wrapGAppsNoGuiHook
=======
, wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, lib
}:

python3.pkgs.buildPythonApplication {
  name = "set-session";

  format = "other";

  src = ./set-session.py;

  dontUnpack = true;

  strictDeps = false;

  nativeBuildInputs = [
<<<<<<< HEAD
    wrapGAppsNoGuiHook
=======
    wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
