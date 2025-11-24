{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  gitUpdater,
  nodejs,
  cmake,
  pkg-config,
  openssl,
  libdatachannel,
  plog,
}:

let
  # Modified from pkgs/by-name/ht/httptoolkit-server/package.nix
  nodeDatachannel = buildNpmPackage {
    pname = "node-datachannel";
    version = "0.10.1";

    src = fetchFromGitHub {
      owner = "murat-dogan";
      repo = "node-datachannel";
      rev = "refs/tags/v${nodeDatachannel.version}";
      hash = "sha256-r5tBg645ikIWm+RU7Muw/JYyd7AMpkImD0Xygtm1MUk=";
    };

    npmFlags = [ "--ignore-scripts" ];

    makeCacheWritable = true;

    npmDepsHash = "sha256-1ZJd0Y45B3CT2YPXDYfCuFMBo5uggWRuDH11eCobyyY=";

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    buildInputs = [
      openssl
      libdatachannel
      plog
    ];

    dontUseCmakeConfigure = true;

    env.NIX_CFLAGS_COMPILE = "-I${nodejs}/include/node";

    preBuild = ''
      # don't use static libs and don't use FetchContent
      substituteInPlace CMakeLists.txt \
          --replace-fail 'OPENSSL_USE_STATIC_LIBS TRUE' 'OPENSSL_USE_STATIC_LIBS FALSE' \
          --replace-fail 'if(NOT libdatachannel)' 'if(false)' \
          --replace-fail 'datachannel-static' 'datachannel'
      sed -i '2ifind_package(plog)' CMakeLists.txt

      # don't fetch node headers
      substituteInPlace node_modules/cmake-js/lib/dist.js \
          --replace-fail '!this.downloaded' 'false'
    '';

    installPhase = ''
      runHook preInstall
      install -Dm755 build/Release/*.node -t $out/build/Release
      runHook postInstall
    '';
  };
in

buildNpmPackage rec {
  pname = "webtorrent-mpv-hook";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "mrxdst";
    repo = "webtorrent-mpv-hook";
    rev = "v${version}";
    hash = "sha256-qFeQBVPZZFKkxz1fhK3+ah3TPDovklhhQwtv09TiSqo=";
  };
  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  postPatch = ''
    substituteInPlace src/webtorrent.ts --replace-fail "node_path: 'node'" "node_path: '${lib.getExe nodejs}'"
    # This executable is just for telling non-Nix users how to install
    substituteInPlace package.json --replace-fail '"bin": "build/bin.mjs",' ""
    rm -rf src/bin.ts
  '';

  npmDepsHash = "sha256-fKzXdbtxC2+63/GZdvPOxvBpQ5rzgvfseigOgpP1n5I=";
  makeCacheWritable = true;
  npmFlags = [ "--ignore-scripts" ];

  postConfigure = ''
    # manually place our prebuilt `node-datachannel` binary into its place, since we used '--ignore-scripts'
    ln -s ${nodeDatachannel}/build node_modules/node-datachannel/build
  '';
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
