let
  # Relative executable paths inside a browser directory, see EXECUTABLE_PATHS
  # in playwright-core's registry (lib/server/registry/index.ts). The aarch64
  # builds are not Chrome-for-Testing, hence the different layout.
  browserPathsBySystem = {
    x86_64-linux = {
      chromium = "chrome-linux64/chrome";
      shell = "chrome-headless-shell-linux64/chrome-headless-shell";
    };
    aarch64-linux = {
      chromium = "chrome-linux/chrome";
      shell = "chrome-linux/headless_shell";
    };
  };
in

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
  bun,
  makeWrapper,
  nodejs,
  stdenv,
  jq,
  ungoogled-chromium,
  # Some providers (e.g. the Cloudflare AI Playground, Gemini web and the
  # ChatGPT web executors) drive a headless Chromium via Playwright. Upstream
  # expects `npx playwright install`, which cannot work in the sandbox, so a
  # nixpkgs Chromium is wired in instead. Set to null to build without browser
  # support. Deliberately not named `chromium`, as that would be auto-filled
  # with `pkgs.chromium` by the by-name callPackage.
  withBrowser ?
    lib.meta.availableOn stdenv.hostPlatform ungoogled-chromium
    && browserPathsBySystem ? ${stdenv.hostPlatform.system},
  nix-update-script,
}:

let
  browserPaths =
    browserPathsBySystem.${stdenv.hostPlatform.system}
      or (throw "omniroute: unsupported system for withBrowser: ${stdenv.hostPlatform.system}");
in

buildNpmPackage (finalAttrs: {
  pname = "omniroute";
  version = "3.8.51";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "diegosouzapw";
    repo = "OmniRoute";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZYRjwynEw3cziFp8tM483QN96mDH0ZuHCFuhcJDwelA=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-YDkHaJp0RDTlwOT79DM+qxSQJ74UjiOFalDiG+nAgpE=";

  # Prevent onnxruntime-node to download GPU support files
  env.ONNXRUNTIME_NODE_INSTALL = "skip";

  # Prevent bun trying to download binaries
  npmFlags = [ "--ignore-scripts" ];

  postPatch = ''
    # The build of opencode-plugin tries to use the internet
    rm -r @omniroute/opencode-plugin
  '';

  nativeBuildInputs = [
    pkg-config
    bun
    makeWrapper
    jq
  ];

  buildInputs = [
    libsecret
  ];

  npmBuildScript = "build:cli";

  postInstall = ''
    # Remove broken symlink
    rm -v $out/lib/node_modules/omniroute/node_modules/@omniroute/browser-pool

  ''
  + lib.optionalString withBrowser ''
    # Playwright only launches a browser whose revision matches the one pinned
    # in its own browsers.json, so `playwright-driver.browsers` cannot be reused
    # here. npm hoists a single playwright-core copy to the top level, but a
    # nested one is picked up too should hoisting ever change. Link every
    # pinned revision to the nixpkgs Chromium instead.
    browsersDir="$out/share/omniroute/playwright-browsers"
    mkdir -p "$browsersDir"

    find "$out/lib/node_modules/omniroute/node_modules" \
      -path '*/playwright-core/browsers.json' \
      -exec jq -r '.browsers[]
        | select(.name == "chromium" or .name == "chromium-headless-shell")
        | "\(.name) \(.revision)"' {} + \
      | sort -u | \
    while read -r name revision; do
      if [ "$name" = chromium ]; then
        relPath="${browserPaths.chromium}"
      else
        relPath="${browserPaths.shell}"
      fi
      # Playwright splits browser directory names on "-", hence the underscores.
      mkdir -p "$(dirname "$browsersDir/''${name//-/_}-$revision/$relPath")"
      ln -s ${lib.getExe ungoogled-chromium} "$browsersDir/''${name//-/_}-$revision/$relPath"
    done
  ''
  + ''

    # Provide required runtime binaries
    wrapProgram $out/bin/omniroute \
      --prefix PATH : ${
        lib.makeBinPath ([ nodejs ] ++ lib.optional withBrowser ungoogled-chromium)
      } ${lib.optionalString withBrowser ''
        \
             --set-default PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1 \
             --set-default PLAYWRIGHT_BROWSERS_PATH "$out/share/omniroute/playwright-browsers" \
             --set-default CLOUDFLARE_PLAYGROUND_CHROME_PATH ${lib.getExe ungoogled-chromium} \
             --set-default CHROME_PATH ${lib.getExe ungoogled-chromium} \
             --set-default OMNIROUTE_LOGIN_BROWSER_PATH ${lib.getExe ungoogled-chromium}''}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI gateway: one endpoint, 290+ providers (90+ free)";
    homepage = "https://omniroute.online/";
    changelog = "https://github.com/diegosouzapw/OmniRoute/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mynacol ];
    mainProgram = "omniroute";
    platforms = lib.platforms.all;
  };
})
