{ stdenv, callPackage, cmake, pkg-config, wrapGAppsHook3
, python3Packages, libnotify, intltool, gnome, gdk-pixbuf, librsvg }:
stdenv.mkDerivation {

  inherit (callPackage ./common-drv-attrs.nix {
    version = "3.2.6";
    pname = "gcdemu";
    hash = "sha256-w4vzKoSotL5Cjfr4Cu4YhNSWXJqS+n/vySrwvbhR1zA=";
  }) pname version src meta;

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook3 intltool ];
  buildInputs = [ python3Packages.pygobject3 libnotify gnome.adwaita-icon-theme gdk-pixbuf librsvg ];

  dontWrapGApps = true;
  postFixup = ''
    wrapProgram $out/bin/gcdemu \
      ''${gappsWrapperArgs[@]} \
      --set PYTHONPATH "$PYTHONPATH"
  '';

}
