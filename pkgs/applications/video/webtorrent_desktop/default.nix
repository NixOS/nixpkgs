{ lib, stdenv, callPackage, runCommand, writeScript, electron_9, nodejs-14_x }:

let
  electron = electron_9;
  nodejs = nodejs-14_x;

  source = lib.importJSON ./source.json;
  pkg = (callPackage ./from-source.nix {
    inherit nodejs;
  })."webtorrent-desktop-git://github.com/webtorrent/webtorrent-desktop.git#${source.rev}".override {
    postInstall = "npm run build";
  };
in

runCommand "webtorrent-desktop-${source.rev}" {
  passthru.updateScript = callPackage ./updater.nix { };
  meta = with stdenv.lib; {
    description = "Streaming torrent app for Mac, Windows, and Linux.";
    homepage = https://webtorrent.io/desktop;
    license = licenses.mit;
    maintainers = [ maintainers.flokli maintainers.bendlas ];
    # FIXME please test on windows and darwin
    hydraPlatforms = [
      "x86_64-linux"
    ];
  };

  inherit (stdenv) shell;
  inherit electron;

} ''
  source ${./substitute-tree.sh}
  substituteTree $out \
    --link ${pkg} . \
    --link ${pkg}/lib/node_modules/webtorrent-desktop/static/linux/share share \
    --substituteAll ${./WebTorrent.in} bin/WebTorrent \
    --substituteInPlace share/applications/webtorrent-desktop.desktop \
      --replace /opt/webtorrent-desktop $out/bin
  chmod +x $out/bin/WebTorrent
''
