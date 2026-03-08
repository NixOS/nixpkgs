{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-rpxy";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "junkurihara";
    repo = "rust-rpxy";
    tag = finalAttrs.version;
    hash = "sha256-TKaOHJSvio1WrrNI9fe9/q32JOCfz764z1Q9emWUgLg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-j5Z0Pvj/v9LfKeDgnP0hGXJcuCXJjCco3Vy0YeFSTzs=";

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
