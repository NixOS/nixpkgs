{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  libsForQt5,
  ffmpeg,
  mpv,
  nodejs,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "stremio-shell";
  version = "4.4.168";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = "stremio-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pz1mie0kJov06GcyitvZu5Gg0Vz3YnigjDqFujGKqZM=";
    fetchSubmodules = true;
    meta.license = lib.licenses.gpl3Only;
  };

  # check server-url.txt
  server = fetchurl rec {
    pname = "stremio-server";
    version = "4.20.8";
    url = "https://dl.strem.io/server/v${version}/desktop/server.js";
    hash = "sha256-cRMgD1d1yVj9FBvFAqgIqwDr+7U3maE8OrCsqExftHY=";
    meta.license = lib.licenses.unfree;
  };

  buildInputs = [
    libsForQt5.qt5.qtwebengine
    mpv
  ];

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qt5.wrapQtAppsHook
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

  meta = {
    mainProgram = "stremio";
    description = "Modern media center that gives you the freedom to watch everything you want";
    homepage = "https://www.stremio.com/";
    # (Server-side) 4.x versions of the web UI are closed-source
    license = with lib.licenses; [
      gpl3Only
      # server.js is unfree
      unfree
    ];
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
    platforms = lib.platforms.linux;
  };
})
