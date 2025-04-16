{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  node-gyp,
  vips,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "librechat";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "danny-avila";
    repo = "LibreChat";
    tag = "v${version}";
    hash = "sha256-U0yIoJt7wE4a7WbryN7hheLRFTRVol5qawIrmKte41M=";
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
  ];

  npmDepsHash = "sha256-r06Hcdxa7pYMqIvNWP4VclJ4woiPd9kJxEmQO88i8J8=";

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
  npmPruneFlags = [ "--omit=dev" ];

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
