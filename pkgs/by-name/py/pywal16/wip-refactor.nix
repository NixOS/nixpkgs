{
  lib,
  python3,
}:

python3.pkgs.toPythonApplication python3.pkgs.pywal16

python3.pkgs.buildPythonPackage (finalAttrs: {

  optional-dependencies = with python3.pkgs; {
    colorthief = [ colorthief ];
    colorz = [ colorz ];
    fast-colorthief = [ fast-colorthief ];
    haishoku = [ haishoku ];
    modern_colorthief = [ modern-colorthief ];
    all = [
      colorthief
      colorz
      fast-colorthief
      haishoku
      modern-colorthief
    ];
  };

})
