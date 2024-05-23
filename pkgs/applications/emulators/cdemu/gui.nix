{ callPackage, cmake, pkg-config, wrapGAppsHook3, gobject-introspection
, python3Packages, libnotify, intltool, gnome, gdk-pixbuf }:
python3Packages.buildPythonApplication {

  inherit (callPackage ./common-drv-attrs.nix {
    version = "3.2.6";
    pname = "gcdemu";
    hash = "sha256-w4vzKoSotL5Cjfr4Cu4YhNSWXJqS+n/vySrwvbhR1zA=";
  }) pname version src meta;

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook3 intltool gobject-introspection ];
  buildInputs = [ libnotify gnome.adwaita-icon-theme gdk-pixbuf ];
  propagatedBuildInputs = with python3Packages; [ pygobject3 ];

  pyproject = false;
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

}
