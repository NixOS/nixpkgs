{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apftool-rs";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "suyulin";
    repo = "apftool-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bcXZIY0CDyWE3vh04IU3kXRxi/uUm5TD8ifA0jq47rc=";
  };

  cargoHash = "sha256-Ufe82fJALRlMjRSQ7Y2wFTOzXKtuwQyrWfxZjdEtuc0=";

  meta = {
    description = "About Tools for Rockchip image unpack tool";
    mainProgram = "apftool-rs";
    homepage = "https://github.com/suyulin/apftool-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ colemickens ];
    platforms = lib.platforms.linux;
  };
})
