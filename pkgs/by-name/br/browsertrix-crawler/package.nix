{
  fetchFromGitHub,
  fetchYarnDeps,
  fetchurl,
  google-chrome,
  jq,
  lib,
  makeWrapper,
  node-gyp,
  nodejs,
  pkg-config,
  python3,
  redis,
  socat,
  stdenv,
  stevenblack-blocklist,
  versionCheckHook,
  vips,
  x11vnc,
  xvfb,
  yarnBuildHook,
  yarnConfigHook,
  ...
}:
let
  version = "1.11.4";

  replayWebPage-version = "2.3.19";
  replayWebPage-ui = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/replaywebpage@${replayWebPage-version}/ui.js";
    hash = "sha256-R7Igm8PiX5F8kscq6/BWUTUgTwlCF58cwu8xcxmFTKQ=";
  };
  replayWebPage-sw = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/replaywebpage@${replayWebPage-version}/sw.js";
    hash = "sha256-E6cSMCVOx+wPWD/iYtwFvqhXxsX7dfxtX81NImM9aho=";
  };
  replayWebPage-adblock = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/replaywebpage@${replayWebPage-version}/adblock/adblock.gz";
    hash = "sha256-GtRs6Si8ndV+mGQxsL0a6w+Q3zINJ880rj9vxuH6fjY=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "browsertrix-crawler";
  inherit version;
  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "browsertrix-crawler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CLKS9lKITUOSbVeAj6XC94E23V5uBfzU5XDGU0tXnzk=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-jcpI8YHsobm8YahW8eK7yZv5oEojdsfJtsbax0SfMig=";
  };

  doCheck = true;

  env.yarnBuildScript = "tsc";
  env.PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = true;
  env.SHARP_FORCE_GLOBAL_LIBVIPS = 1;

  strictDeps = true;

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    nodejs
    node-gyp
    makeWrapper
    pkg-config
    python3
    versionCheckHook
  ];

  buildInputs = [
    vips
  ];

  patches = [
    ./replace-default-path.patch
  ];

  preBuild = ''
    mkdir -p $HOME/.node-gyp/${nodejs.version}
    echo 9 > $HOME/.node-gyp/${nodejs.version}/installVersion
    ln -sfv ${nodejs}/include $HOME/.node-gyp/${nodejs.version}
    export npm_config_nodedir=${nodejs}

    pkg-config --modversion vips-cpp
    (cd node_modules/sharp && yarn --offline run install)
  '';

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/{bin,lib/node_modules/browsertrix-crawler/html/rwp}

    cp -rv ./* $out/lib/node_modules/browsertrix-crawler/

    cp ${replayWebPage-ui} $out/lib/node_modules/browsertrix-crawler/html/rwp/ui.js
    cp ${replayWebPage-sw} $out/lib/node_modules/browsertrix-crawler/html/rwp/sw.js
    cp ${replayWebPage-adblock} $out/lib/node_modules/browsertrix-crawler/html/rwp/adblock.gz
    grep '^0\.0\.0\.0 ' ${stevenblack-blocklist}/hosts \
      | awk '{ print $2; }' \
      | grep -v '0\.0\.0\.0\( \|$\)' \
      | ${lib.getExe jq} --raw-input --slurp 'split("\n")' \
        > $out/lib/node_modules/browsertrix-crawler/ad-hosts.json

    makeWrapper ${lib.getExe nodejs} $out/bin/browsertrix-crawl \
      --add-flag --experimental-global-webcrypto \
      --add-flag $out/lib/node_modules/browsertrix-crawler/dist/main.js \
      --prefix PATH : ${
        lib.makeBinPath [
          redis
          xvfb
        ]
      } \
      --set BROWSER_BIN ${lib.getExe google-chrome} \
      --set BROWSER_VERSION ${google-chrome.version} \
      --set-default GEOMETRY "1360x1020x16" \
      --set-default VNC_PASS "vncpassw0rd!" \
      --set-default DETACHED_CHILD_PROC "1"

    ln -s $out/bin/browsertrix-crawl $out/bin/browsertrix-qa

    makeWrapper ${lib.getExe nodejs} $out/bin/browsertrix-create-login-profile \
      --add-flag $out/lib/node_modules/browsertrix-crawler/dist/create-login-profile.js \
      --prefix PATH : ${
        lib.makeBinPath [
          socat
          x11vnc
          xvfb
        ]
      } \
      --set BROWSER_BIN ${lib.getExe google-chrome} \
      --set BROWSER_VERSION ${google-chrome.version} \
      --set-default GEOMETRY "1360x1020x16" \
      --set-default VNC_PASS "vncpassw0rd!" \
      --set-default DETACHED_CHILD_PROC "1"

    runHook postInstall
  '';

  meta = {
    description = "Browser-based crawling system";
    homepage = "https://crawler.docs.browsertrix.com";
    license = lib.licenses.agpl3Plus;
    mainProgram = "browsertrix-crawl";
    maintainers = [ lib.maintainers.skyesoss ];
  };
})
