{
  bash,
  writers,
  python3Packages
}:
let
  pythonPackages = python3Packages;
  writeCheckedBashBin = name:
    let
      interpreter = "${bash}/bin/bash";
    in writers.makeScriptWriter {
      inherit interpreter;
      check = "${interpreter} -n $1";
    } "/bin/${name}";

  # Helpers used during build/development.
  lint = writeCheckedBashBin "lint" ''
    ${pythonPackages.flake8}/bin/flake8 --show-source ''${@}
  '';

  unittest = writeCheckedBashBin "unittest" ''
    if [ "$#" -eq 0 ]; then
      set -- discover -p '*_test.py'
    fi

    ${pythonPackages.python}/bin/python -m unittest "''${@}"
  '';

  format = writeCheckedBashBin "format" ''
    ${pythonPackages.autopep8}/bin/autopep8 -r -i . "''${@}"
  '';
in {
  inherit format lint unittest;
}

