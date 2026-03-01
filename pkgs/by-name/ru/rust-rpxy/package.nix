{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-rpxy";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "junkurihara";
    repo = "rust-rpxy";
    tag = finalAttrs.version;
    hash = "sha256-KGg+OtQj1PIp/zbViPTyAUvm6bRzWB1l6ktpDEOIDYM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Fe/64ytHYBf1/VvWVGWrXiqHwAcoUh76zgHJ8FbTbzE=";

  meta = {
    description = "Http reverse proxy serving multiple domain names and terminating TLS for http/1.1, 2 and 3, written in Rust";
    homepage = "https://github.com/junkurihara/rust-rpxy";
    changelog = "https://github.com/junkurihara/rust-rpxy/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [
      jpteb
    ];
    mainProgram = "rpxy";
    platforms = lib.platforms.all;
  };
})
