{ lib, stdenv, themix-gui, python3
, enableColorthief ? true
, enableColorz ? true
, enableHaishoku ? true
}:

stdenv.mkDerivation rec {
  pname = "themix-import-images";

  inherit (themix-gui) version src;

  propagatedBuildInputs = with python3.pkgs; [ pillow ]
    ++ lib.optionals enableColorthief [ colorthief ]
    ++ lib.optionals enableColorz [ colorz ]
    ++ lib.optionals enableHaishoku [ haishoku ];

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
