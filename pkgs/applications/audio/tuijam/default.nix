{ buildPythonApplication
, fetchFromGitHub
, lib
, python3Packages
, youtube-dl
}:

buildPythonApplication rec {
  pname = "tuijam";
  version = "unstable-2020-06-05";

  src = fetchFromGitHub {
    owner = "cfangmeier";
    repo = pname;
    rev = "7baec6f6e80ee90da0d0363b430dd7d5695ff03b";
    sha256 = "1l0s88jvj99jkxnczw5nfj78m8vihh29g815n4mg9jblad23mgx5";
  };

  buildInputs = [ python3Packages.Babel ];

  # the package has no tests
  doCheck = false;

  propagatedBuildInputs = with python3Packages; [
    gmusicapi
    google_api_python_client
    mpv
    pydbus
    pygobject3
    pyyaml
    requests
    rsa
    urwid
  ];

  meta = with lib; {
    description = "A fancy TUI client for Google Play Music";
    longDescription = ''
      TUIJam seeks to make a simple, attractive, terminal-based interface to
      listening to music for Google Play Music All-Access subscribers.
    '';
    homepage    = "https://github.com/cfangmeier/tuijam";
    license     = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}
