{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
  bun,
  makeWrapper,
  nodejs-slim,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "omniroute";
  version = "3.8.49";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "diegosouzapw";
    repo = "OmniRoute";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nRLziV4NWPoa0ev57DV7jmAvLpL/1MP1EMZO2/drrTU=";
  };

  npmDepsHash = "sha256-R0u93MLUUWC8xFgq4S0Aj/7wg4pygTKwxP/eWkWMgCw=";

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
  ];

  buildInputs = [
    libsecret
  ];

  npmBuildScript = "build:cli";

  # Provide required runtime binaries
  postInstall = ''
    wrapProgram $out/bin/omniroute \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs-slim
        ]
      }
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
