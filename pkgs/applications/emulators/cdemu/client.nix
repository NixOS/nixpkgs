{ callPackage, python3Packages, intltool, wrapGAppsNoGuiHook }:
callPackage ./base.nix {
  version = "3.2.5";
  pname = "cdemu-client";
  hash = "sha256-py2F61v8vO0BCM18GCflAiD48deZjbMM6wqoCDZsOd8=";
  nativeBuildInputs = [ intltool wrapGAppsNoGuiHook ];
  buildInputs = with python3Packages; [ dbus-python pygobject3 ];
  postFixup = ''
    wrapProgram $out/bin/cdemu \
      --set PYTHONPATH "$PYTHONPATH"
  '';
}
