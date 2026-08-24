{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bootimage";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = "bootimage";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Q/9T+6JZPfPV3DvMqNkFHow6gBpbk3HQcbfuTaAxwHo=";
  };

  cargoHash = "sha256-UylacTDWZVkoyAA7fDsX1v+8TMnynIIfE3v+vxDXxyY=";

  meta = {
    description = "Creates a bootable disk image from a Rust OS kernel";
    homepage = "https://github.com/rust-osdev/bootimage";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ dbeckwith ];
  };
})
