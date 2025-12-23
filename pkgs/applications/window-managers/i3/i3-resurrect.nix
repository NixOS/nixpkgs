{
  lib,
  buildPythonApplication,
  click,
  i3ipc,
  psutil,
  natsort,
  fetchPypi,
  xprop,
  xdotool,
  importlib-metadata,
}:

buildPythonApplication rec {
  pname = "i3-resurrect";
  version = "1.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-13FKRvEE4vHq5G51G1UyBnfNiWeS9Q/SYCG16E1Sn4c=";
  };

  propagatedBuildInputs = [
    click
    psutil
    xprop
    natsort
    i3ipc
    xdotool
    importlib-metadata
  ];
  doCheck = false; # no tests

  meta = {
    homepage = "https://github.com/JonnyHaystack/i3-resurrect";
    description = "Simple but flexible solution to saving and restoring i3 workspaces";
    mainProgram = "i3-resurrect";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ magnetophon ];
  };
}
