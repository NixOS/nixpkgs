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
  playwright-driver,
  playwright-test,
  # Some providers (e.g. the Cloudflare AI Playground, Gemini web and the
  # ChatGPT web executors) drive a headless Chromium via Playwright. Upstream
  # expects `npx playwright install`, which cannot work in the sandbox, so the
  # nixpkgs Playwright and its matching browsers are wired in instead.
  withBrowser ? lib.meta.availableOn stdenv.hostPlatform playwright-driver,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "omniroute";
  version = "3.8.52";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "diegosouzapw";
    repo = "OmniRoute";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k4+iy6aFWaFxVPcTStR4xNCJjw/UHeMqb5XnEvuqJZU=";
  };

  patches = [
    # @swc/core >= 1.16.13 ships its native addon as a compressed "carrier"
    # that extracts itself into a cache directory on first load. Its security
    # checks reject every cache root in the build sandbox, because / is owned
    # by the unmapped overflow uid. 1.16.17 added an opt-out (see the env var
    # below). Remove once upstream ships an @swc/core containing
    # https://github.com/swc-project/swc/pull/12547.
    ./swc-core-1.16.18.patch
  ];

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-ec5Ak3B4aJwXXNILd/xFg2GS5Z8O/1XdDuA5Sp7XRl8=";

  env = {
    # Prevent onnxruntime-node to download GPU support files
    ONNXRUNTIME_NODE_INSTALL = "skip";
    # See the @swc/core patch above
    SWC_NATIVE_BINDING_CACHE_SKIP_SECURITY_CHECK = "1";
  };

  # Prevent bun trying to download binaries
  npmFlags = [ "--ignore-scripts" ];

  postPatch = ''
    # The build of opencode-plugin tries to use the internet
    rm -r @omniroute/opencode-plugin
  '';

  # Playwright only launches browsers matching the revisions pinned in its own
  # browsers.json, so replace the locked copy with the nixpkgs one, for which
  # playwright-driver provides the browsers.
  preBuild = ''
    for pkg in playwright playwright-core; do
      rm -r "node_modules/$pkg"
      cp -r --no-preserve=mode ${playwright-test}/lib/node_modules/$pkg "node_modules/$pkg"
    done
  '';

  nativeBuildInputs = [
    pkg-config
    bun
    makeWrapper
  ];

  buildInputs = [
    libsecret
  ];

  npmBuildScript = "build:cli";

  postInstall = ''
    # Remove broken symlink
    rm -v $out/lib/node_modules/omniroute/node_modules/@omniroute/browser-pool

    # Replace playwright in the output (after npm pack) again
    for pkg in playwright playwright-core; do
      rm -r "$out/lib/node_modules/omniroute/node_modules/$pkg"
      ln -s ${playwright-test}/lib/node_modules/$pkg "$out/lib/node_modules/omniroute/node_modules/$pkg"
    done

    # Provide required runtime binaries
    wrapProgram $out/bin/omniroute \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} ${lib.optionalString withBrowser ''
        \
             --set-default PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD 1 \
             --set-default PLAYWRIGHT_BROWSERS_PATH ${playwright-driver.browsers}''}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI gateway supporting 300+ providers";
    homepage = "https://omniroute.online/";
    changelog = "https://github.com/diegosouzapw/OmniRoute/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mynacol ];
    mainProgram = "omniroute";
  };
})
