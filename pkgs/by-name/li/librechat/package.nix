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
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "danny-avila";
    repo = "LibreChat";
    tag = "v${version}";
    hash = "sha256-0HEb8tFpiTjfN+RpwizK5POWsz5cRicSdZwYPmUaLDA=";
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
    # Since 0.7.9, there are two more files that try to write logs to the package
    # directory. We patch the log directory to target the current working directory
    # instead for these two as well.
    ./0004-logs-v079.patch
  ];

  npmDepsHash = "sha256-tOxanPXry52lD39xlT6rqKVF+Pk6m3FpTv/8wctKAWY=";

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

  # For reasons beyond my understanding, the api directory disappears after the build finishes.
  # Hence, starting LibreChat fails with a "module not found" error due to a broken symlink.
  # This is a fixup that copies the missing files to the appropriate location.
  preFixup = ''
    mkdir -p $out/lib/node_modules/LibreChat/packages/api
    cp -R packages/api/dist/. $out/lib/node_modules/LibreChat/packages/api
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
