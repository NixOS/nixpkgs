{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_file";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = "nu_plugin_file";
    rev = "13789b93384b39dd25377d9801504f786bc5158e";
    hash = "sha256-play1lKAboy4bgmlTQ2Cw6OEuxAmGrd5iI2erkGJFK8=";
  };

  cargoHash = "sha256-lGxwrkjQPK054cmMs0livc8g3MBlQex+m1XUBlDxjWs=";

  nativeBuildInputs = lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Nushell plugin to inspect file formats using magic bytes";
    mainProgram = "nu_plugin_file";
    homepage = "https://github.com/fdncred/nu_plugin_file";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
