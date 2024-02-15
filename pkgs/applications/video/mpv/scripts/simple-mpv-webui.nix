{ lib, buildLua
, fetchFromGitHub
, gitUpdater
}:
buildLua rec {
  pname = "simple-mpv-ui";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "open-dynaMIX";
    repo = "simple-mpv-webui";
    rev = "v${version}";
    hash = "sha256-I8lwpo3Hfpy3UnPMmHEJCdArVQnNL245NkxsYVmnMF0=";
    sparseCheckout = [ "main.lua" "webui-page" ];
  };
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  scriptPath = ".";
  passthru.scriptName = "webui";

  meta = with lib; {
    description = "A web based user interface with controls for the mpv mediaplayer";
    homepage = "https://github.com/open-dynaMIX/simple-mpv-webui";
    maintainers = with maintainers; [ cript0nauta zopieux ];
    longDescription = ''
      You can access the webui when accessing http://127.0.0.1:8080 or
      http://[::1]:8080 in your webbrowser. By default it listens on
      0.0.0.0:8080 and [::0]:8080
    '';
    license = licenses.mit;
  };
}
