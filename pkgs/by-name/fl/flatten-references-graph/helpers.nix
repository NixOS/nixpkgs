{
  bash,
  writers,
  python3Packages,
}:
let
  writeCheckedBashBin =
    name:
    let
      interpreter = "${bash}/bin/bash";
    in
    writers.makeScriptWriter {
      inherit interpreter;
      check = "${interpreter} -n $1";
    } "/bin/${name}";

  # Helpers used during build/development.
  lint = writeCheckedBashBin "lint" ''
    ${python3Packages.flake8}/bin/flake8 --show-source ''${@}
  '';

  unittest = writeCheckedBashBin "unittest" ''
    if [ "$#" -eq 0 ]; then
      set -- discover -p '*_test.py'
    fi

    ${python3Packages.python}/bin/python -m unittest "''${@}"
  '';

  format = writeCheckedBashBin "format" ''
    ${python3Packages.autopep8}/bin/autopep8 -r -i . "''${@}"
  '';
in
{
  inherit format lint unittest;
}
