{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  pkg-config,
  node-gyp,
  vips,
  nix-update-script,
  nixosTests,
}:

buildNpmPackage (finalAttrs: {
  pname = "librechat";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "danny-avila";
    repo = "LibreChat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iU5UoH1rbt+cVEzZAmiSjRKMJdQrKtqtHTT6vf5bGrg=";
  };

  patches = [
    # `buildNpmPackage` relies on `npm pack`, which only includes files explicitly
    # listed in the project's package.json `files` array if this property is set.
    # LibreChat does not set this property, but we can avoid packaging the whole
    # workspace by simply adding the relevant paths here ourselves.
    # Also, we set the `bin` property to the server script to benefit from the
    # auto-generated wrapper.
    ./0001-npm-pack.patch
    # User uploads are by default written to the package directory as well.
    # We patch this to be relative to the current working directory instead.
    ./0002-upload-paths.patch
  ];

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-mtGqMl+u/BfcrXKiOjtgOcgDFFgBzKt56TvpbrXPG5E=";

  # npm dependency install fails with nodejs_24: https://github.com/NixOS/nixpkgs/issues/474535
  nodejs = nodejs_22;

  nativeBuildInputs = [
    pkg-config
    node-gyp
  ];

  buildInputs = [
    vips
  ];

  npmBuildScript = "frontend";
  npmPruneFlags = [ "--production" ];

  makeWrapperArgs = [
    # Upstream defaults to the immutable package directory.
    # As a functioning default, we set this to the current working directory (through a relative logs path),
    # but make it easy for the module to override.
    "--set-default LIBRECHAT_LOG_DIR ./logs"
  ];

  # npmConfigHook only patches the root node_modules
  postConfigure = ''
    patchShebangs client/node_modules
  '';

  # For reasons beyond my understanding, the api and client directory disappears after the build finishes.
  # Hence, the build fails with broken symlinks and if the symlink is removed,
  # starting LibreChat fails with a "module not found" error.
  # This is a fixup that copies the missing files to the appropriate location.
  preFixup = ''
    mkdir -p $out/lib/node_modules/LibreChat/packages/api
    cp -R packages/api/dist/. $out/lib/node_modules/LibreChat/packages/api
    mkdir -p $out/lib/node_modules/LibreChat/packages/client
    cp -R packages/client/dist/. $out/lib/node_modules/LibreChat/packages/client
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
    tests = {
      inherit (nixosTests) librechat;
    };
  };

  meta = {
    description = "Open-source app for all your AI conversations, fully customizable and compatible with any AI provider";
    homepage = "https://github.com/danny-avila/LibreChat";
    changelog = "https://www.librechat.ai/changelog/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gepbird
      niklaskorz
    ];
    mainProgram = "librechat-server";
  };
})
