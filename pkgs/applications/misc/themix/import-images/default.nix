{ stdenv, themix-gui, python3
# TODO: These optional python packages are not available in nixpkgs.
# , enableColorthief ? false
# , enableColorz ? false
# , enableHaishoku ? false
}:

let
  inherit (stdenv.lib) optionals;
in

stdenv.mkDerivation rec {
  pname = "themix-import-images";

  inherit (themix-gui) version src;

  propagatedBuildInputs = with python3.pkgs; [ pillow ];

  buildPhase = ''
    runHook preBuild
    python -O -m compileall plugins/import_pil
    runHook postBuild
  '';

  # No tests
  doCheck = false;

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  installTargets = "install_import_images";

  meta = {
    description = "Plugin for Themix GUI designer to get color palettes from images";
    inherit (themix-gui.meta)
    homepage
    license
    maintainers
    platforms;
  };
}
