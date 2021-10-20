{ lib, buildPythonApplication, click, i3ipc, psutil, natsort, fetchPypi, xprop, xdotool, importlib-metadata }:

buildPythonApplication rec {
  pname = "i3-resurrect";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h181frdwpqfj9agw43qgicdvzv1i7xwky0vs0ksd8h18qxqp4hr";
  };

  propagatedBuildInputs = [ click psutil xprop natsort i3ipc xdotool importlib-metadata ];
  doCheck = false; # no tests

  meta = with lib; {
    homepage = "https://github.com/JonnyHaystack/i3-resurrect";
    description = "A simple but flexible solution to saving and restoring i3 workspaces";
    license = licenses.gpl3;
    platforms= platforms.linux;
    maintainers = with maintainers; [ magnetophon ];
  };
}
