{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "impala";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "impala";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uCazIX3HToznF2jjTu9+uUeLp2CoQ8cKiP+SxwWlH64=";
  };

  cargoHash = "sha256-w8pxZchekifoTzxgiNzUKvx2hsu45EZPr54do2iFmUo=";

  # fix for compilation of musl builds on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  postPatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "TUI for managing wifi";
    homepage = "https://github.com/pythops/impala";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      nydragon
      saadndm
    ];
    mainProgram = "impala";
  };
})
