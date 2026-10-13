{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_bson";
  # NOTE: v26.1140.0 does not build: its Cargo.toml requires nu-plugin ^0.114.0
  # while its Cargo.lock still pins 0.113.1.
  version = "26.1150.0";

  src = fetchFromGitHub {
    owner = "Kissaki";
    repo = "nu_plugin_bson";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZStHZ8WL2zYTNVH+iq2jIKfXIoaS/2rPfyfHu5MdN98=";
  };

  cargoHash = "sha256-mWqcyCZg/u6ymr7p1KIMbls6Nn6DA9LJ3pr3WIt3g3Q=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for BSON (Binary JSON) format `from bson` and `to bson`";
    homepage = "https://github.com/Kissaki/nu_plugin_bson";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "nu_plugin_bson";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
    # "Plugin `bson` is compiled for nushell version 0.113.0, which is not
    # compatible with version 0.115.1".
    # Upstream's main branch has already bumped to nu-plugin 0.115.0, so this
    # should be unbroken by the next release.
    broken = true;
  };
})
