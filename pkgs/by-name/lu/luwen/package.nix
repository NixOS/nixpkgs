{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luwen";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "tenstorrent";
    repo = "luwen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P/D9u620OxJGoJO41D5okJcoBGXDDIoYwIIMIDS5Uv0=";
  };

  cargoHash = "sha256-3jxFjydslWax5Ub0G8UNT11gZbPZpPvK8U1+1nlKb38=";

  meta = {
    description = "Tenstorrent system interface tools";
    homepage = "https://github.com/tenstorrent/luwen";
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    license = with lib.licenses; [ asl20 ];
  };
})
