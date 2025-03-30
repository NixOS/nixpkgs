{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
  vimUtils,
}:
let
  version = "2.2.3";
  src = fetchFromGitHub {
    owner = "vyfor";
    repo = "cord.nvim";
    tag = "v${version}";
    hash = "sha256-MhUjQxwATAGxIC8ACNDFDm249GzX4Npq3S+sHoUMuos=";
  };
  cord-server = rustPlatform.buildRustPackage {
    pname = "cord";
    version = "2.2.3";
    inherit src;

    # The version in .github/server-version.txt differs from the one in Cargo.toml
    postPatch = ''
      substituteInPlace .github/server-version.txt \
        --replace-fail "2.0.0-beta.30" "${version}"
    '';

    useFetchCargoVendor = true;
    cargoHash = "sha256-hKt9d2u/tlD7bgo49O8oHDLljRvad9dEpGdFt+LH6Ec=";

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
        "'${cord-server}'"
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
