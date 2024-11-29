{
  buildPythonPackage,
  pluggy,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "pluggy-tests";
  inherit (pluggy) version;
  format = "other";

  inherit (pluggy) src;

  dontBuild = true;
  dontInstall = true;

  nativeCheckInputs = [
    pluggy
    pytestCheckHook
  ];
}
