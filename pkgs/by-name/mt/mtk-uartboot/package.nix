{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mtk-uartboot";
  version = "0-unstable-2024-12-07";

  src = fetchFromGitHub {
    owner = "981213";
    repo = "mtk_uartboot";
    rev = "b0ec7bdf1bab7089df948e745e17d206f3426dc1";
    hash = "sha256-wUF1e0TfP9khfC9WruJkIg4j4DClOJTTPRABIe4Ma4U=";
  };

  cargoHash = "sha256-DtYCSPcyLDYeo9fIQpHGdm5r6ijRAzsDExWcDuSvh/o=";

  meta = {
    description = "Tool to load and execute binaries over UART for Mediatek SoCs";
    homepage = "https://github.com/981213/mtk_uartboot";
    license = lib.licenses.agpl3Only;
    mainProgram = "mtk_uartboot";
    maintainers = [ lib.maintainers.jmbaur ];
    platforms = lib.platforms.unix;
  };
})
