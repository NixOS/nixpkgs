{ lib, stdenv, electron, buildNpmPackage, fetchFromGitHub, fetchpatch }:

buildNpmPackage {
  pname = "webtorrent-desktop";
  version = "0.25-pre-1eb612";
  src = fetchFromGitHub {
    owner = "webtorrent";
    repo = "webtorrent-desktop";
    rev = "1eb61201d6360698a2cc4ea72bf0fa7ee78b457c";
    sha256 = "sha256-DBEFOamncyidMXypvKNnUmDIPUq1LzYjDgox7fa4+Gg=";
  };
  patches = [
    # electron 27 fix
    (fetchpatch {
      url = "https://github.com/webtorrent/webtorrent-desktop/pull/2388.patch";
      hash = "sha256-gam5oAZtsaiCNFwecA5ff0nhraySLx3SOHlb/js+cPM=";
    })
    # startup fix
    (fetchpatch {
      url = "https://github.com/webtorrent/webtorrent-desktop/pull/2389.patch";
      hash = "sha256-hBJGLNNjcGRhYOFlLm/RL0po+70tEeJtR6Y/CfacPAI=";
    })
  ];
  npmDepsHash = "sha256-tqhp3jDb1xtyV/n9kJtzkiznLQfqeYWeZiTnTVV0ibE=";
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
    exec ${electron}/bin/electron --no-sandbox $out/lib/webtorrent-desktop "\$@"
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
    maintainers = [ maintainers.bendlas ];
    mainProgram = "WebTorrent";
  };

}
