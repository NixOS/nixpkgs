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
    description = "AI gateway: one endpoint, 290+ providers (90+ free)";
    homepage = "https://omniroute.online/";
    changelog = "https://github.com/diegosouzapw/OmniRoute/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mynacol ];
    mainProgram = "omniroute";
    platforms = lib.platforms.all;
  };
})
