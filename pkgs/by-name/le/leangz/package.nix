{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  pkg-config,
  zstd,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leangz";
  # nixpkgs-update: no auto update
  version = "0.1.20"; # Should match LEANTAR_VERSION in leanprover/lean4/CMakeLists.txt

  src = fetchFromGitHub {
    owner = "digama0";
    repo = "leangz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EDei1ykLtjj8Qd9soL2p0h8lL+wQOgi5vQGWDbf1NK4=";
  };

  cargoHash = "sha256-h0cbvqmX5p0/Me6kPKpcuMUcVivII2n4Z0D/DNyAVDI=";

  __structuredAttrs = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ zstd ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Lean 4 .olean file (de)compressor";
    homepage = "https://github.com/digama0/leangz";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ niklashh ];
    mainProgram = "leantar";
  };
})
