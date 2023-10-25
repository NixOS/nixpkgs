{ lib, stdenv, electron_22, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage {
  pname = "webtorrent-desktop";
  version = "0.25-pre";
  src = fetchFromGitHub {
    owner = "webtorrent";
    repo = "webtorrent-desktop";
    rev = "fce078defefd575cb35a5c79d3d9f96affc8a08f";
    sha256 = "sha256-gXFiG36qqR0QHTqhaxgQKDO0UCHkJLnVwUTQB/Nct/c=";
  };
  npmDepsHash = "sha256-pEuvstrZ9oMdJ/iU6XwEQ1BYOyQp/ce6sYBTrMCjGMc=";
  makeCacheWritable = true;
  npmRebuildFlags = [ "--ignore-scripts" ];
  installPhase = ''
    ## Rebuild node_modules for production
    ## after babel compile has finished
    rm -r node_modules
    export NODE_ENV=production
    npm ci --ignore-scripts

    ## delete unused files
    rm -r test

    ## delete config for build time cache
    npm config delete cache

    ## add script wrapper and desktop files; icons
    mkdir -p $out/lib $out/bin $out/share/applications
    cp -r . $out/lib/webtorrent-desktop
    cat > $out/bin/WebTorrent <<EOF
    #! ${stdenv.shell}
    set -eu
    exec ${electron_22}/bin/electron --no-sandbox $out/lib/webtorrent-desktop "\$@"
    EOF
    chmod +x $out/bin/WebTorrent
    cp -r static/linux/share/icons $out/share/
    sed "s#/opt/webtorrent-desktop#$out/bin#" \
      < static/linux/share/applications/webtorrent-desktop.desktop \
      > $out/share/applications/webtorrent-desktop.desktop
  '';

  meta = with lib; {
    description = "Streaming torrent app for Mac, Windows, and Linux";
    homepage = "https://webtorrent.io/desktop";
    license = licenses.mit;
    maintainers = [ maintainers.flokli maintainers.bendlas ];
  };

}
