{ lib
, python3Packages
, taskwarrior
, glibcLocales
}:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.1.0";
  disabled = lib.versionOlder python.version "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd34f0b827953dfdecdc39f8416d41c50c24576c33a512a047a71c1263eb3e0f";
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
    homepage = "https://github.com/scottkosty/vit";
    description = "Visual Interactive Taskwarrior";
    maintainers = with maintainers; [ dtzWill arcnmx ];
    platforms = platforms.all;
    license = licenses.mit;
  };
}
