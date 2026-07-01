{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-rpxy";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "junkurihara";
    repo = "rust-rpxy";
    tag = finalAttrs.version;
    hash = "sha256-fdpr6HWMuMT0nXj7V5JQbiLVOGoWaTsX1OI+yCEErDA=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-WsK7eQffO+Ehx6H2Jj99XWON1Wc3Ud5Yaq1Nyz/oeSY=";

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
