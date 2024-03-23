{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, ffmpeg
, mpv
, nodejs
, qmake
, qtwebchannel
, qtwebengine
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "stremio-shell";
  version = "4.4.165";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-Gky0/HaGm11PeV4twoQV71T99NG2o0mYzQxu/c9x5oE=";
  };

  server = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/stremio-artifacts/four/v${version}/server.js";
    sha256 = "sha256-52Pg0PrV15arGqhD3rXYCl1J6kcoL+/BHRvgiQBO/OA=";
  };

  buildInputs = [ qtwebengine mpv ];

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

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
    description = "A modern media center that gives you the freedom to watch everything you want.";
    homepage = "https://www.stremio.com/";
    # (Server-side) web UI is closed source now, apparently they work on open-sourcing it.
    # server.js appears to be MIT-licensed, but I can't find how they actually build it.
    # https://www.reddit.com/r/StremioAddons/comments/n2ob04/a_summary_of_how_stremio_works_internally_and/
    license = with licenses; [ gpl3 mit ];
    maintainers = with maintainers; [ abbradar ];
    platforms = platforms.linux;
  };
}
