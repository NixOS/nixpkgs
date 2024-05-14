{ callPackage, python3Packages, intltool, wrapGAppsNoGuiHook }:
callPackage ./base.nix {
  version = "3.2.5";
  pname = "cdemu-client";
  sha256 = "1prrdhv0ia0axc6b73crszqzh802wlkihz6d100yvg7wbgmqabd7";
  nativeBuildInputs = [ intltool wrapGAppsNoGuiHook ];
  buildInputs = with python3Packages; [ dbus-python pygobject3 ];
  postFixup = ''
    wrapProgram $out/bin/cdemu \
      --set PYTHONPATH "$PYTHONPATH"
  '';
}
