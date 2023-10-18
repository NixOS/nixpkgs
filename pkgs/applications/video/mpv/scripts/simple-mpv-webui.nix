{ lib, buildLua
, fetchFromGitHub }:
buildLua rec {
  pname = "simple-mpv-ui";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "open-dynaMIX";
    repo = "simple-mpv-webui";
    rev = "v${version}";
    sha256 = "1z0y8sdv5mbxznxqh43w5592ym688vkvqg7w26p8cinrhf09pbw8";
  };

  scriptPath = "webui.lua";
  postInstall = "cp -a webui-page $out/share/mpv/scripts/";

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
