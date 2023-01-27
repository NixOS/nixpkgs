{ lib , buildNpmPackage , fetchFromGitHub, nodejs }:

buildNpmPackage rec {
  pname = "webtorrent-mpv-hook";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "mrxdst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AFKX31kriacXygZy0Mw+QwO+SwFEu13687mJ/WeAoKY=";
  };

  postPatch = ''
    substituteInPlace src/webtorrent.ts --replace "node_path: 'node'" "node_path: '${nodejs}/bin/node'"
    # This executable is just for telling non-Nix users how to install
    substituteInPlace package.json --replace '"bin": "build/bin.js",' ""
    rm -rf src/bin.ts
  '';

  npmDepsHash = "sha256-GpNUJ5ZCgMjSYLqsIE/RwkTSFT3uAhxrHPe7XvGDRHE=";
  makeCacheWritable = true;

  postInstall = ''
    mkdir -p $out/share/mpv/scripts/
    ln -s $out/lib/node_modules/webtorrent-mpv-hook/build/webtorrent.js $out/share/mpv/scripts/
  '';
  passthru.scriptName = "webtorrent.js";

  meta = {
    description = "Adds a hook that allows mpv to stream torrents";
    homepage = "https://github.com/mrxdst/webtorrent-mpv-hook";
    maintainers = [ lib.maintainers.chuangzhu ];
    license = lib.licenses.isc;
  };
}
