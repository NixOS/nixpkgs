{
  cmake,
  pkg-config,
  callPackage,
  gobject-introspection,
  wrapGAppsHook3,
  python3Packages,
  libxml2,
  gnuplot,
  gnome,
  gdk-pixbuf,
  intltool,
  libmirage,
}:
python3Packages.buildPythonApplication {

  inherit
    (callPackage ./common-drv-attrs.nix {
      version = "3.2.6";
      pname = "image-analyzer";
      hash = "sha256-7I8RUgd+k3cEzskJGbziv1f0/eo5QQXn62wGh/Y5ozc=";
    })
    pname
    version
    src
    meta
    ;

  buildInputs = [
    libxml2
    gnuplot
    libmirage
    gnome.adwaita-icon-theme
    gdk-pixbuf
  ];
  propagatedBuildInputs = with python3Packages; [
    pygobject3
    matplotlib
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    intltool
    gobject-introspection
  ];

  pyproject = false;
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

}
