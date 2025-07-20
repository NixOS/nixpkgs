{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  vimUtils,
}:
let
  version = "2.2.7";
  src = fetchFromGitHub {
    owner = "vyfor";
    repo = "cord.nvim";
    tag = "v${version}";
    hash = "sha256-SONErPOIaRltx51+GCsGtR0FDSWp/36x3lDbYLSMxXM=";
  };
  cord-server = rustPlatform.buildRustPackage {
    pname = "cord";
    inherit src version;

    # The version in .github/server-version.txt differs from the one in Cargo.toml
    postPatch = ''
      substituteInPlace .github/server-version.txt \
        --replace-fail "2.2.6" "${version}"
    '';

    cargoHash = "sha256-14u3rhpDYNKZ4YLoGp6OPeeXDo3EzGYO3yhE9BkDSC0=";

    # cord depends on nightly features
    RUSTC_BOOTSTRAP = 1;

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    versionCheckProgramArg = "--version";
    doInstallCheck = false;

    meta.mainProgram = "cord";
  };
in
vimUtils.buildVimPlugin {
  pname = "cord.nvim";
  inherit version src;

  # Patch the logic used to find the path to the cord server
  # This still lets the user set config.advanced.server.executable_path
  # https://github.com/vyfor/cord.nvim/blob/v2.2.3/lua/cord/server/fs/init.lua#L10-L15
  postPatch = ''
    substituteInPlace lua/cord/server/fs/init.lua \
      --replace-fail \
        "or M.get_data_path()" \
        "or '${cord-server}'"
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "vimPlugins.cord-nvim.cord-nvim-rust";
    };

    # needed for the update script
    inherit cord-server;
  };

  meta = {
    homepage = "https://github.com/vyfor/cord.nvim";
    license = lib.licenses.asl20;
    changelog = "https://github.com/vyfor/cord.nvim/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
