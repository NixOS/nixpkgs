{
  stdenv,
  lib,
  rustPlatform,
  pkg-config,
  nix-update-script,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_hcl";
  version = "0.113.1";

  src = fetchFromGitHub {
    owner = "Yethal";
    repo = "nu_plugin_hcl";
    tag = finalAttrs.version;
    hash = "sha256-4rbYbyIYy3WEn2hSkreohVWJ8zhQHI/cdBN5xO4YKdY=";
  };

  cargoHash = "sha256-lFlG86yGR61jgmKxTp2FYir2o0vEAVeoPk1owDGGWLM=";

  nativeBuildInputs = [ pkg-config ] ++ lib.optionals stdenv.cc.isClang [ rustPlatform.bindgenHook ];

  # there are no tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nushell plugin for parsing Hashicorp Configuration Language files";
    mainProgram = "nu_plugin_hcl";
    homepage = "https://github.com/Yethal/nu_plugin_hcl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yethal ];
  };
})
