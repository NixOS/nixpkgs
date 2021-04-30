{ lib, stdenv, themix-gui, python3 }:

stdenv.mkDerivation rec {
  pname = "themix-import-images";

  inherit (themix-gui) version src;

  propagatedBuildInputs = with python3.pkgs; [ pillow colorthief colorz haishoku ];

  buildPhase = ''
    runHook preBuild
    python -O -m compileall plugins/import_pil
    runHook postBuild
  '';

  # No tests
  doCheck = false;

  installFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  installTargets = "install_import_images";

  meta = themix-gui.meta // {
    description = "Plugin for Themix GUI designer to get color palettes from images";
  };
}
