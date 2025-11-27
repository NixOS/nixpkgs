{
  lib,
  buildNpmPackage,
  fetchNpmDeps,
  fetchFromGitHub,
  pkg-config,
  node-gyp,
  vips,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "librechat";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "danny-avila";
    repo = "LibreChat";
    tag = "v${version}";
    hash = "sha256-DTmb9J2nsMy6f+V6BgRtFgpTwOi9OQnvikSx4QZQ0HI=";
  };

  patches = [
    # `buildNpmPackage` relies on `npm pack`, which only includes files explicitly
    # listed in the project's package.json `files` array if this property is set.
    # LibreChat does not set this property, but we can avoid packaging the whole
    # workspace by simply adding the relevant paths here ourselves.
    # Also, we set the `bin` property to the server script to benefit from the
    # auto-generated wrapper.
    ./0001-npm-pack.patch
    # LibreChat tries writing logs to the package directory, which is immutable
    # in our case. We patch the log directory to target the current working directory
    # instead, which in case of NixOS will be the service's data directory.
    ./0002-logs.patch
    # Similarly to the logs, user uploads are by default written to the package
    # directory as well. Again, we patch this to be relative to the current working
    # directory instead.
    ./0003-upload-paths.patch
    # The npm dependencies are causing issues with the build. The package @testing-library/react
    # appears to not be included in NPM deps, even though it is present in the project
    # This patch fixes this by placing the dependency in different files and regenerating the
    # lock file.
    ./0004-fix-deps-v080.patch
  ];

  npmDepsHash = "sha256-97cEw6VD7FoVayrxClHuS1iUcQmDw7/aUoUV6ektvOY=";
  npmDeps = fetchNpmDeps {
    inherit src;
    name = "${pname}-${version}-npm-deps-patched";
    hash = npmDepsHash;
    patches = [ ./0004-fix-deps-v080.patch ];
  };

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
  };

  meta = {
    description = "Open-source app for all your AI conversations, fully customizable and compatible with any AI provider";
    homepage = "https://github.com/danny-avila/LibreChat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ niklaskorz ];
    mainProgram = "librechat-server";
  };
}
