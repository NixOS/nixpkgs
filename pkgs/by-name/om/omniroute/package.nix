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
  nix-update-script,
}:

let
  browserPaths =
    browserPathsBySystem.${stdenv.hostPlatform.system}
      or (throw "omniroute: unsupported system for withBrowser: ${stdenv.hostPlatform.system}");
in

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

    # Provide required runtime binaries
    wrapProgram $out/bin/omniroute \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI gateway supporting 300+ providers";
    homepage = "https://omniroute.online/";
    changelog = "https://github.com/diegosouzapw/OmniRoute/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mynacol ];
    mainProgram = "omniroute";
    platforms = lib.platforms.all;
  };
})
