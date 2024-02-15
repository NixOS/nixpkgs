{ lib, buildNpmPackage, fetchFromGitHub, gitUpdater, nodejs, python3 }:

buildNpmPackage rec {
  pname = "webtorrent-mpv-hook";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "mrxdst";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/dMtXcIyfAs++Zgz2CxRW0tkzn5QjS+WVGChlCyrU0U=";
  };
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  postPatch = ''
    substituteInPlace src/webtorrent.ts --replace "node_path: 'node'" "node_path: '${nodejs}/bin/node'"
    # This executable is just for telling non-Nix users how to install
    substituteInPlace package.json --replace '"bin": "build/bin.mjs",' ""
    rm -rf src/bin.ts
  '';

  npmDepsHash = "sha256-EqHPBoYyBuW9elxQH/XVTZoPkKHC6+7aksYo60t7WA4=";
  makeCacheWritable = true;

  nativeBuildInputs = [
    python3 # Fixes node-gyp on aarch64-linux
  ];

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
