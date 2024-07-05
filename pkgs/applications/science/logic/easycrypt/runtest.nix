{ python3Packages, easycrypt }:

python3Packages.buildPythonApplication rec {
  inherit (easycrypt) src version;
  format = "other";

  pname = "easycrypt-runtest";

  dontConfigure = true;
  dontBuild = true;
  doCheck = false;

  pythonPath = with python3Packages; [ pyyaml ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp scripts/testing/runtest $out/bin/ec-runtest
    runHook postInstall
  '';

  meta = easycrypt.meta // {
    description = "Testing program for EasyCrypt formalizations";
    mainProgram = "ec-runtest";
  };
}
