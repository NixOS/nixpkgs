{
  fetchFromGitHub,
  node-gyp-build,
  makeBinaryWrapper,
  nodejs,
  pnpm_10,
  python3,
  stdenv,
  unixtools,
  cctools,
  lib,
  nixosTests,
  enableLocalIcons ? false,
}:
let
  dashboardIcons = fetchFromGitHub {
    owner = "homarr-labs";
    repo = "dashboard-icons";
    rev = "f222c55843b888a82e9f2fe2697365841cbe6025"; # Until 2025-07-11
    hash = "sha256-VOWQh8ZadsqNInoXcRKYuXfWn5MK0qJpuYEWgM7Pny8=";
  };

  installLocalIcons = ''
    mkdir -p $out/share/homepage/public/icons
    cp -r --no-preserve=mode ${dashboardIcons}/png/. $out/share/homepage/public/icons
    cp -r --no-preserve=mode ${dashboardIcons}/svg/. $out/share/homepage/public/icons
    cp ${dashboardIcons}/LICENSE $out/share/homepage/public/icons/
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "homepage-dashboard";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "gethomepage";
    repo = "homepage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-03am9z381UozNsmWZefopMp8/tLycXJyiZ5BUGaV1kY=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 1;
    hash = "sha256-svkqmRFwZpcExFWtAbLL0lpHhzsI2s7RiLfQajIqjck=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm_10.configHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools ];

  buildInputs = [
    node-gyp-build
  ];

  env.PYTHON = "${python3}/bin/python";

  preBuild = ''
    # patch next.js file-system-cache to use NIXPKGS_HOMEPAGE_CACHE_DIR
    # related:
    # * https://github.com/NixOS/nixpkgs/issues/328621 ("homepage-dashboard: Failed to update prerender cache")
    # * https://github.com/NixOS/nixpkgs/pull/337902 ("nixos/homepage-dashboard: set an explicit cache dir")
    # * https://github.com/NixOS/nixpkgs/issues/458494 ("homepage-dashboard: Dashboard styles are destroyed after a server restart")

    # source file
    substituteInPlace node_modules/next/dist/server/lib/incremental-cache/file-system-cache.js \
      --replace-fail 'this.serverDistDir = ctx.serverDistDir;' \
                     'this.serverDistDir = require("path").join((process.env.NIXPKGS_HOMEPAGE_CACHE_DIR || "/var/cache/homepage-dashboard"), "homepage");'

    # bundled runtimes
    for bundle in node_modules/next/dist/compiled/next-server/*.runtime.prod.js; do
      substituteInPlace "$bundle" \
        --replace-fail 'this.serverDistDir=e.serverDistDir' \
                       'this.serverDistDir=(process.env.NIXPKGS_HOMEPAGE_CACHE_DIR||"/var/cache/homepage-dashboard")+"/homepage"'
    done
  '';

  buildPhase = ''
    runHook preBuild
    mkdir -p config
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cp -r .next/standalone $out/share/homepage/
    cp -r public $out/share/homepage/public
    chmod +x $out/share/homepage/server.js

    mkdir -p $out/share/homepage/.next
    cp -r .next/static $out/share/homepage/.next/static

    makeWrapper "${lib.getExe nodejs}" $out/bin/homepage \
      --set-default PORT 3000 \
      --set-default HOMEPAGE_CONFIG_DIR /var/lib/homepage-dashboard \
      --set-default NIXPKGS_HOMEPAGE_CACHE_DIR /var/cache/homepage-dashboard \
      --add-flags "$out/share/homepage/server.js" \
      --prefix PATH : "${lib.makeBinPath [ unixtools.ping ]}"

    ${if enableLocalIcons then installLocalIcons else ""}

    runHook postInstall
  '';

  doDist = false;

  passthru = {
    tests = {
      inherit (nixosTests) homepage-dashboard;
    };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Highly customisable dashboard with Docker and service API integrations";
    changelog = "https://github.com/gethomepage/homepage/releases/tag/v${finalAttrs.version}";
    mainProgram = "homepage";
    homepage = "https://gethomepage.dev";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ parthiv-krishna ];
    platforms = lib.platforms.all;
  };
})
