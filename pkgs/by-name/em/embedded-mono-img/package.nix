{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "embedded-mono-img";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "embedded-mono-img";
    tag = "v${version}";
    hash = "sha256-eOW7DMNNmgJYcScfBwowxAJPSJbwAP55ZgqCAftH36U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-6J2x+v52sL1UbggD3dDz7/kIKgfAjiCf4IvD9c6eGYs=";

  meta = {
    description = "Convert .png images to raw binary for embedded_graphics";
    homepage = "https://github.com/kpcyrd/embedded-mono-img";
    changelog = "https://github.com/kpcyrd/embedded-mono-img/releases/tag/v${version}";
    mainProgram = "embedded-mono-img";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [ kpcyrd ];
    platforms = lib.platforms.all;
  };
}
