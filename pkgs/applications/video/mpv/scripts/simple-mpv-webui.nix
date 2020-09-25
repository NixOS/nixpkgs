{ stdenv
, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "simple-mpv-ui";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "open-dynaMIX";
    repo = "simple-mpv-webui";
    rev = "v${version}";
    sha256 = "1glrnnl1slcl0ri0zs4j64lc9aa52p9ffh6av0d81fk95nm98917";
  };

  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/mpv/scripts
    cp -r webui.lua webui-page $out/share/mpv/scripts/
  '';
  passthru.scriptName = "webui.lua";

  meta = with stdenv.lib; {
    description = "A web based user interface with controls for the mpv mediaplayer";
    homepage = "https://github.com/open-dynaMIX/simple-mpv-webui";
    maintainers = [ maintainers.cript0nauta ];
    longDescription = ''
      You can access the webui when accessing http://127.0.0.1:8080 or
      http://[::1]:8080 in your webbrowser. By default it listens on
      0.0.0.0:8080 and [::0]:8080
    '';
    license = licenses.mit;
  };
}

