{ lib
, python3Packages
, taskwarrior
, glibcLocales
}:

with python3Packages;

buildPythonApplication rec {
  pname = "vit";
  version = "2.2.0";
  disabled = lib.versionOlder python.version "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6GbIc5giuecxUqswyaAJw675R1M8BvelyyRNFcTqKW8=";
  };

  propagatedBuildInputs = [
    tasklib
    urwid
  ];

  nativeCheckInputs = [ glibcLocales ];

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
