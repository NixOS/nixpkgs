{ inkscape, runCommand, writeTextFile }:

let
  svg_file = writeTextFile {
    name = "test.svg";
    text = ''
<?xml version="1.0" encoding="UTF-8"?>
<svg width="50" height="50" version="1.1">
  <ellipse cx="1" cy="1" rx="1" ry="1" />
</svg>'';
  };
in
runCommand "inkscape-test-eps"
{
  nativeBuildInputs = [ inkscape ];
} ''
  echo ps test
  inkscape ${svg_file} --export-type=ps -o test.ps
  inkscape test.ps -o test.ps.svg

  echo eps test
  inkscape ${svg_file} --export-type=eps -o test.eps
  inkscape test.eps -o test.eps.svg

  # inkscape does not return an error code, only does not create files
  [[ -f test.ps.svg && -f test.eps.svg ]] && touch $out
''
