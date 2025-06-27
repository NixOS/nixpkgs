{
  lib,
  fetchFromGitLab,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "honeyfetch";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "ahoneybun";
    repo = "honeyfetch";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-07pNmfPxjrsdvWSRrFtugHeQ7BTF9bwGW0ICQDSn6Pg=";
  };

  cargoHash = "sha256-m4On01dLwpgomRfCWljSjGxUN4N3KeaN1W5zGptTIOA=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A classy neofetch but in Rust";
    homepage = "https://gitlab.com/ahoneybun/honeyfetch";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ahoneybun ];
    mainProgram = "honeyfetch";
    platforms = lib.platforms.all;
  };
})
