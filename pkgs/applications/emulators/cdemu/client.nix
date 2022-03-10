{ callPackage, python3Packages, intltool, makeWrapper }:
let pkg = import ./base.nix {
  version = "3.2.5";
  pname = "cdemu-client";
  pkgSha256 = "1prrdhv0ia0axc6b73crszqzh802wlkihz6d100yvg7wbgmqabd7";
};
in callPackage pkg {
  buildInputs = [ python3Packages.python python3Packages.dbus-python python3Packages.pygobject3
                  intltool makeWrapper ];
  drvParams = {
    postFixup = ''
      wrapProgram $out/bin/cdemu \
        --set PYTHONPATH "$PYTHONPATH"
    '';
  };
}
