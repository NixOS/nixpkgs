{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mermaid-rs-renderer";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "1jehuang";
    repo = "mermaid-rs-renderer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lQCloOhTqqEU8MNrkUmmJFdoOTEE3j5nvZJo21GJlMU=";
  };

  cargoHash = "sha256-IETAA/TTbdFaZYHMx8imV0cdnq+2VSgU1a4AdcSuxGM=";

  meta = {
    description = "A fast native Rust Mermaid diagram renderer. No browser required. 500-1000x faster than mermaid-cli";
    homepage = "https://github.com/1jehuang/mermaid-rs-renderer";
    changelog = "https://github.com/1jehuang/mermaid-rs-renderer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "mmdr";
  };
})
