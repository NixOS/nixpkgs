{ lib
, bc
, fetchFromGitHub
, jq
, python3
}:

let
  pythonPackages = python3.pkgs;
  finalAttrs = {
    pname = "pyp";
    version = "1.2.0";

    src = fetchFromGitHub {
      owner = "hauntsaninja";
      repo = "pyp";
      rev = "refs/tags/v${finalAttrs.version}";
      hash = "sha256-hnEgqWOIVj2ugOhd2aS9IulfkVnrlkhwOtrgH4qQqO8=";
    };

    pyproject = true;

    build-system = with pythonPackages; [
      flit-core
    ];

    nativeCheckInputs = (with pythonPackages; [
      pytestCheckHook
    ]) ++ [
      bc
      jq
    ];

    pythonImportsCheck = [
      "pyp"
    ];

    # without this, the tests fail because they are unable to find the pyp tool
    # itself...
    preCheck = ''
      _OLD_PATH_=$PATH
      PATH=$out/bin:$PATH
   '';

    # And a cleanup!
    postCheck = ''
      PATH=$_OLD_PATH_
    '';

    meta = {
      homepage = "https://github.com/hauntsaninja/pyp";
      description = "Easily run Python at the shell";
      changelog = "https://github.com/hauntsaninja/pyp/blob/${finalAttrs.version}/CHANGELOG.md";
      license = with lib.licenses; [ mit ];
      mainProgram = "pyp";
      maintainers = with lib.maintainers; [ rmcgibbo AndersonTorres ];
    };
  };
in
pythonPackages.buildPythonPackage finalAttrs
