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

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-13FKRvEE4vHq5G51G1UyBnfNiWeS9Q/SYCG16E1Sn4c=";
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

  meta = with lib; {
    homepage = "https://github.com/JonnyHaystack/i3-resurrect";
    description = "A simple but flexible solution to saving and restoring i3 workspaces";
    mainProgram = "i3-resurrect";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
  };
}
