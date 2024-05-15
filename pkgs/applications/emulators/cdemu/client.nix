{ stdenv, callPackage, python3Packages, cmake, pkg-config, intltool, wrapGAppsNoGuiHook }:
stdenv.mkDerivation {

  inherit (callPackage ./common-drv-attrs.nix {
    version = "3.2.5";
    pname = "cdemu-client";
    hash = "sha256-py2F61v8vO0BCM18GCflAiD48deZjbMM6wqoCDZsOd8=";
  }) pname version src meta;

  nativeBuildInputs = [ cmake pkg-config intltool wrapGAppsNoGuiHook ];
  buildInputs = with python3Packages; [ dbus-python pygobject3 ];

  dontWrapGApps = true;
  postFixup = ''
    wrapProgram $out/bin/cdemu \
      ''${gappsWrapperArgs[@]} \
      --set PYTHONPATH "$PYTHONPATH"
  '';

}
