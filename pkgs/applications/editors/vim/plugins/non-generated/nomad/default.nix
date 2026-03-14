{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  pkg-config,
  stdenv,
  dbus,
}:
rustPlatform.buildRustPackage (self: {
  pname = "nomad";
  version = "2025.11.2";
  src = fetchFromGitHub {
    owner = "nomad";
    repo = "nomad";
    tag = self.version;
    hash = "sha256-fF70G5fTrOHKxZ/EB6+Q0pyOEjfvAd30BL70xr3DKeM=";
  };

  cargoHash = "sha256-tNFCT5Puddj2K2HCQd/ENdmZ6mSruWczA3RvbTrEeQg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = lib.lists.optionals stdenv.isLinux [
    dbus
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $out
    cargo xtask neovim build --release --out-dir=$out
    runHook postBuild
  '';

  # the xtask build takes care of installing
  doInstall = false;

  env = {
    RUSTC_BOOTSTRAP = 1; # We need rust unstable features

    # nomad's `version` build script tries to determine the version using git if these are not set.
    RELEASE_TAG = self.version;
    COMMIT_HASH = self.src.rev;
    COMMIT_UNIX_TIMESTAMP = "0";
  };

  passthru = {
    vimPlugin = true;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Real-time collaborative editing in Neovim";
    homepage = "https://github.com/nomad/nomad";
    changelog = "https://github.com/nomad/nomad/blob/${self.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
  };
})
