{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bootimage";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "rust-osdev";
    repo = "bootimage";
    rev = "v${finalAttrs.version}";
    hash = "sha256-74/aaZR+KHlZjZRuxeXjaLKjja1/7OaHjuMQOmZF4Yo=";
  };

  cargoHash = "sha256-CkFJHW7yrIJi/KMGJgyhnLTMkrxnDwO3X4M1aml9cuM=";

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
