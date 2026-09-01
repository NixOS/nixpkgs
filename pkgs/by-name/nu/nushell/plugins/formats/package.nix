{
  stdenv,
  lib,
  rustPlatform,
  nushell,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_formats";
  inherit (nushell) version src cargoHash;

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  buildAndTestSubdir = "crates/nu_plugin_formats";

  passthru.updateScript = nix-update-script {
    # Skip the version check and only check the hash because we inherit version from nushell.
    extraArgs = [ "--version=skip" ];
  };

  meta = {
    description = "Formats plugin for Nushell";
    mainProgram = "nu_plugin_formats";
    homepage = "https://github.com/nushell/nushell/tree/${finalAttrs.version}/crates/nu_plugin_formats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      viraptor
    ];
  };
})
