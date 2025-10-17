{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixdoc";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixdoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7UOjmW8Ef4mEvj7SINaKWh2ZuyNMVEXB82mtuZTQiPA=";
  };

  cargoHash = "sha256-Aw794yhIET8/pnlQiK2xKVbYC/Kd5MExvFTwkv4LLTc=";

  meta = {
    description = "Generate documentation for Nix functions";
    mainProgram = "nixdoc";
    homepage = "https://github.com/nix-community/nixdoc";
    license = [ lib.licenses.gpl3 ];
    maintainers = with lib.maintainers; [
      infinisil
      hsjobeki
    ];
    platforms = lib.platforms.unix;
  };
})
