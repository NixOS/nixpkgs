{ pkgs, python2Packages }:

let
  pname = "python-openstackclient";
  version = "3.11.0";
  name = "${pname}-${version}";

  withMaintainer = args : pkgs.lib.recursiveUpdate args {
    meta.maintainers = [ pkgs.stdenv.lib.maintainers.lewo ];
    };

  mkDerivation = args: if builtins.getAttr "name" args == name
                       then python2Packages.buildPythonApplication (withMaintainer args)
		       else python2Packages.buildPythonPackage args;
  generated = import ./requirements_generated.nix { inherit pkgs mkDerivation; } ;
in
  builtins.getAttr pname (pkgs.lib.fix generated)
