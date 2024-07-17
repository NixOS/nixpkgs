{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "open-in-mpv";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "Baldomo";
    repo = "open-in-mpv";
    rev = "v${version}";
    hash = "sha256-Fa6oZMaR0ctZgYWoOXLaobc+pDRDZbDCFvRZUR+Fda4=";
  };

  vendorHash = "sha256-G6GZO2+CfEAYcf7zBcqDa808A0eJjM8dq7+4VGZ+P4c=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    install -Dm444 -t $out/share/applications scripts/open-in-mpv.desktop
  '';

  meta = with lib; {
    description = "Simple web extension to open videos in mpv";
    longDescription = ''
      To function the browser extension must be installed and open-in-mpv must be set as the default scheme-handler for mpv:// eg.:
        xdg-mime default open-in-mpv.desktop x-scheme-handler/mpv

      https://addons.mozilla.org/en-US/firefox/addon/iina-open-in-mpv/
      https://chrome.google.com/webstore/detail/open-in-mpv/ggijpepdpiehgbiknmfpfbhcalffjlbj
    '';
    homepage = "https://github.com/Baldomo/open-in-mpv";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 ];
    mainProgram = "open-in-mpv";
  };
}
