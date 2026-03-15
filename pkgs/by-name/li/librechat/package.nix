{
  lib,
  buildNpmPackage,
  fetchNpmDeps,
  fetchFromGitHub,
  nodejs_22,
  pkg-config,
  node-gyp,
  vips,
  nix-update-script,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "librechat";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "danny-avila";
    repo = "LibreChat";
    tag = "v${version}";
    hash = "sha256-91VQg+dN6nYNWywUsoQZ1SXPT2Vyc0X6j9irKcm5/fM=";
  };

  patches = [
    # `buildNpmPackage` relies on `npm pack`, which only includes files explicitly
    # listed in the project's package.json `files` array if this property is set.
    # LibreChat does not set this property, but we can avoid packaging the whole
    # workspace by simply adding the relevant paths here ourselves.
    # Also, we set the `bin` property to the server script to benefit from the
    # auto-generated wrapper.
    ./0001-npm-pack.patch
    # LibreChat tries writing user uploads logs to the package directory, which is immutable
    # in our case. We patch the upload directory to target the current working directory
    # instead, which in case of NixOS will be the service's data directory.
    ./0002-upload-paths.patch
  ];

  npmDepsHash = "sha256-gUUbEZ9tR6ozLmcxwxmaAlE7eampEhhQTmuPsDCypO8=";
  npmDepsFetcherVersion = 2;

  # npm dependency install fails with nodejs_24: https://github.com/NixOS/nixpkgs/issues/474535
  nodejs = nodejs_22;

  nativeBuildInputs = [
    pkg-config
    node-gyp
  ];

  buildInputs = [
    vips
  ];

  # required for sharp
  makeCacheWritable = true;

  npmBuildScript = "frontend";
  npmPruneFlags = [ "--production" ];

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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ niklaskorz ];
    mainProgram = "librechat-server";
  };
}
