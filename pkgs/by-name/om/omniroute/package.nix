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
  withBrowser ? lib.meta.availableOn stdenv.hostPlatform ungoogled-chromium,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "omniroute";
  version = "3.8.50";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "diegosouzapw";
    repo = "OmniRoute";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+2FMc9wrvPtQS3+mGsBVvKrd5RprYe/r/GJvjAVMBpc=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-wa5vQMYugA8E7lXOh4lgNH7JNbKOinNaW6Zk8Mw2e8k=";

  # Prevent onnxruntime-node to download GPU support files
  env.ONNXRUNTIME_NODE_INSTALL = "skip";

  # Prevent bun trying to download binaries
  npmFlags = [ "--ignore-scripts" ];

  patches = [
    # Prevent next.js from downloading Google Fonts during build
    ./disable-google-fonts.patch
  ];

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
    # here (the two vendored playwright-core copies pin different revisions).
    # Link every pinned revision to the nixpkgs Chromium instead.
    browsersDir="$out/share/omniroute/playwright-browsers"

    # Layout is platform dependent, see EXECUTABLE_PATHS in playwright-core's
    # registry (lib/server/registry/index.ts).
    ${
      if stdenv.hostPlatform.isAarch64 then
        ''
          chromiumPath="chrome-linux/chrome"
          shellPath="chrome-linux/headless_shell"
        ''
      else
        ''
          chromiumPath="chrome-linux64/chrome"
          shellPath="chrome-headless-shell-linux64/chrome-headless-shell"
        ''
    }

    jq -r '.browsers[]
      | select(.name == "chromium" or .name == "chromium-headless-shell")
      | "\(.name) \(.revision)"' \
      $out/lib/node_modules/omniroute/node_modules/playwright-core/browsers.json \
      $out/lib/node_modules/omniroute/node_modules/playwright/node_modules/playwright-core/browsers.json \
      | sort -u | \
    while read -r name revision; do
      if [ "$name" = chromium ]; then relPath="$chromiumPath"; else relPath="$shellPath"; fi
      mkdir -p "$(dirname "$browsersDir/''${name//-/_}-$revision/$relPath")"
      ln -s ${lib.getExe ungoogled-chromium} "$browsersDir/''${name//-/_}-$revision/$relPath"
    done

    # Marker file, without it playwright considers the install incomplete.
    touch "$browsersDir/.links"
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
