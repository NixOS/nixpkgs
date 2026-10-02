{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apftool-rs";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "suyulin";
    repo = "afptool-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5cNxwkL1oHWMcZus27yNeC/pT7DCWJ+GDUY16NZ/0yE=";
  };

  cargoHash = "sha256-4Zvu+5BKYO5EWllbYgp31ZRPL0SBqDN0QOMjQUFZyUM=";

  meta = {
    description = "About Tools for Rockchip image unpack tool";
    mainProgram = "apftool-rs";
    homepage = "https://github.com/suyulin/afptool-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ colemickens ];
    platforms = lib.platforms.linux;
  };
})
