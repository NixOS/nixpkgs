{ lib
, python3Packages
, glibcLocales
, taskwarrior }:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.0.0";
  disabled = lib.versionOlder python.version "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5282d8076d9814d9248071aec8784cffbd968601542533ccb28ca61d1d08205e";
  };

  propagatedBuildInputs = [
    pytz
    tasklib
    tzlocal
    urwid
  ];
  checkInputs = [ glibcLocales ];

  makeWrapperArgs = [ "--suffix" "PATH" ":" "${taskwarrior}/bin" ];

  preCheck = ''
    export TERM=''${TERM-linux}
  '';

  meta = with lib; {
    homepage = https://github.com/scottkosty/vit;
    description = "Visual Interactive Taskwarrior";
    maintainers = with maintainers; [ dtzWill arcnmx ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
