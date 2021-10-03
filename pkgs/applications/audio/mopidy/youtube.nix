{ lib, python3Packages, mopidy }:

python3Packages.buildPythonApplication rec {
  pname = "mopidy-youtube";
  version = "3.4";

  src = python3Packages.fetchPypi {
    inherit version;
    pname = "Mopidy-YouTube";
    sha256 = "sha256-996MNByMcKq1woDGK6jsmAHS9TOoBrwSGgPmcShvTRw=";
  };

  postPatch = "sed s/bs4/beautifulsoup4/ -i setup.cfg";

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    cachetools
    youtube-dl
    ytmusicapi
  ] ++ [ mopidy ];

  doCheck = false;

  meta = with lib; {
    description = "Mopidy extension for playing music from YouTube";
    license = licenses.asl20;
    maintainers = [ maintainers.spwhitt ];
  };
}
