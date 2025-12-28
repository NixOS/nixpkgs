{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "bsol-grub2-theme";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "harishnkr";
    repo = "bsol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sUvlue+AXW6VkVYy3WOUuSt548b6LoDpJmQPbgcZDQw=";
  };

  # Skip build phase
  dontBuild = true;

  installPhase = ''
    cp -r bsol/ $out/
  '';

  # Allow auto-update using `nixpkgs-update` ran by the update bot
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "grub2 blue-screen-of-life theme";
    homepage = "https://github.com/harishnkr/bsol";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ BlueskyFR ];
    platforms = lib.platforms.linux;
  };
})
