{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pasfmt";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "integrated-application-development";
    repo = "pasfmt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-f8aXZdgiZJS/iIKgqisx97g/IRL5skstsb788QFffV4=";
  };

  cargoHash = "sha256-hSPFgf2G7JBFbnejuBwCdmt2xnLosu+OPO51UVt1QtA=";

  meta = {
    description = "Delphi/Pascal code formatter";
    homepage = "https://github.com/integrated-application-development/pasfmt";
    changelog = "https://github.com/integrated-application-development/pasfmt/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ daru-san ];
    mainProgram = "pasfmt";
  };
})
