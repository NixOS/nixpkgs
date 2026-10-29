{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "i3altlayout";
  version = "0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-DhOYeSCxKthr2fEMGMBXjUYeCJjj6AV4d05So4eDF8A=";
  };

  pythonRemoveDeps = [ "enum-compat" ];

  pythonPath = with python3Packages; [
    i3ipc
    docopt
  ];

  doCheck = false;

  pythonImportsCheck = [ "i3altlayout" ];

  meta = {
    maintainers = with lib.maintainers; [ magnetophon ];
    description = "Helps you handle more efficiently your screen real estate in i3wm by auto-splitting windows on their longest side";
    mainProgram = "i3altlayout";
    homepage = "https://github.com/deadc0de6/i3altlayout";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
})
