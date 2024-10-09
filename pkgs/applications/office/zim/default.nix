{ lib, stdenv, fetchurl, python3Packages, gtk3, gobject-introspection, wrapGAppsHook3, adwaita-icon-theme }:

# TODO: Declare configuration options for the following optional dependencies:
#  -  File stores: hg, git, bzr
#  -  Included plugins depenencies: dot, ditaa, dia, any other?
#  -  pyxdg: Need to make it work first (see setupPyInstallFlags).

python3Packages.buildPythonApplication rec {
  pname = "zim";
  version = "0.75.2";

  src = fetchurl {
    url = "https://zim-wiki.org/downloads/zim-${version}.tar.gz";
    hash = "sha256-QIkNsFsWeNHEcXhGHHZyJDMMW2lNvdwMJLGxeCZaLdI=";
  };

  buildInputs = [ gtk3 adwaita-icon-theme ];
  propagatedBuildInputs = with python3Packages; [ pyxdg pygobject3 ];
  nativeBuildInputs = [ gobject-introspection wrapGAppsHook3 ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(--prefix XDG_DATA_DIRS : $out/share)
    makeWrapperArgs+=(--prefix XDG_DATA_DIRS : ${adwaita-icon-theme}/share)
    makeWrapperArgs+=(--argv0 $out/bin/.zim-wrapped)
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postInstall = ''
    (
      cd icons
      for img in *.{png,svg}; do
        size=''${img#zim}
        size=''${size%.png}
        size=''${size%.svg}
        dimensions="''${size}x''${size}"
        mkdir -p $out/share/icons/hicolor/$dimensions/apps
        cp $img $out/share/icons/hicolor/$dimensions/apps/${pname}.png
      done
    )
  '';

  # RuntimeError: could not create GtkClipboard object
  doCheck = false;

  checkPhase = ''
    ${python3Packages.python.interpreter} test.py
  '';

  meta = with lib; {
    description = "Desktop wiki";
    homepage = "https://zim-wiki.org/";
    changelog = "https://github.com/zim-desktop-wiki/zim-desktop-wiki/blob/${version}/CHANGELOG.md";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ pSub ];
    mainProgram = "zim";
    broken = stdenv.hostPlatform.isDarwin; # https://github.com/NixOS/nixpkgs/pull/52658#issuecomment-449565790
  };
}
