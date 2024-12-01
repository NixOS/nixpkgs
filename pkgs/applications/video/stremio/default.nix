{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  ffmpeg,
  mpv,
  nodejs,
  qmake,
  qtwebengine,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "stremio-shell";
  version = "4.4.168";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-pz1mie0kJov06GcyitvZu5Gg0Vz3YnigjDqFujGKqZM=";
  };

  server = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/stremio-artifacts/four/v${version}/server.js";
    hash = "sha256-aD3niQpgq1EiZLacnEFgmqUV+bc4rvGN9IA+9T4XF10=";
  };

  buildInputs = [
    qtwebengine
    mpv
  ];

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  postInstall = ''
    mkdir -p $out/{bin,share/applications}
    ln -s $out/opt/stremio/stremio $out/bin/stremio
    mv $out/opt/stremio/smartcode-stremio.desktop $out/share/applications
    install -Dm 644 images/stremio_window.png $out/share/pixmaps/smartcode-stremio.png
    ln -s ${nodejs}/bin/node $out/opt/stremio/node
    ln -s $server $out/opt/stremio/server.js
    wrapProgram $out/bin/stremio \
      --suffix PATH ":" ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = with lib; {
    mainProgram = "stremio";
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://www.stremio.com/";
    # (Server-side) web UI is closed source now, apparently they work on open-sourcing it.
    # server.js appears to be MIT-licensed, but I can't find how they actually build it.
    # https://www.reddit.com/r/StremioAddons/comments/n2ob04/a_summary_of_how_stremio_works_internally_and/
    license = with licenses; [
      gpl3
      mit
    ];
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
