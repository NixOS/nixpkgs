{ callPackage, python3Packages, cmake, pkg-config, intltool, wrapGAppsNoGuiHook, gobject-introspection }:
python3Packages.buildPythonApplication {

  inherit (callPackage ./common-drv-attrs.nix {
    version = "3.2.5";
    pname = "cdemu-client";
    hash = "sha256-py2F61v8vO0BCM18GCflAiD48deZjbMM6wqoCDZsOd8=";
  }) pname version src meta;

  nativeBuildInputs = [ cmake pkg-config intltool wrapGAppsNoGuiHook gobject-introspection ];
  propagatedBuildInputs = with python3Packages; [ dbus-python pygobject3 ];

  pyproject = false;
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

}
