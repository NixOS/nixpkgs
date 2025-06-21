{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libudev-zero,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "deepcool-digital-linux";
  version = "0.8.3-alpha";

  src = fetchFromGitHub {
    owner = "Nortank12";
    repo = "deepcool-digital-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Whmjd6NCOUkE7hM3FaN7grMwcC/suL7AJDVSgnZSKzM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-K1pEbUyENPUS4QK0lztWmw8ov1fGrx8KHdODmSByfek=";

  buildInputs = [ libudev-zero ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Linux version for the DeepCool Digital Windows software";
    homepage = "https://github.com/Nortank12/deepcool-digital-linux";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ NotAShelf ];
    mainProgram = "deepcool-digital-linux";
  };
})
