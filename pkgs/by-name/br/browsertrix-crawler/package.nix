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
  version = "1.12.4";

  replayWebPage-version = "2.4.3";
  replayWebPage-ui = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/replaywebpage@${replayWebPage-version}/ui.js";
    hash = "sha256-Ay8T7LW11OKRbAaEkZrjU4c8QVjbpfzol1gtnhjkMuE=";
  };
  replayWebPage-sw = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/replaywebpage@${replayWebPage-version}/sw.js";
    hash = "sha256-pGM9gApE2H52Kp1Lfdynwm1bXgDo0O1akS6MBwqdkPA=";
  };
  replayWebPage-adblock = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/replaywebpage@${replayWebPage-version}/adblock/adblock.gz";
    hash = "sha256-mWm1egyxahV9D60AB5+XIAU8Cf1UmNw4pyKfKhmMIZg=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "browsertrix-crawler";
  inherit version;
  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "browsertrix-crawler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eHcn9XA35GFWNv3L5bF34ltjcSSut0henjWQ1vrHLhU=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-jqXSCbFf8SGUE11Ed8JhPbGUGDUgjFyMfbH1goLq1XY=";
  };

  __structuredAttrs = true;

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
