{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  createSymlinks ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stash-clipboard";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "stash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HnKYO6TSX3RNkC2DDBgb6brX8bFrKw4kg0RBwZXZMDI=";
  };

  cargoHash = "sha256-PP/jh6AJPmjg93zSN0E8QLE+bN77edAV/dHxdtPy9+4=";

  __structuredAttrs = true;

  postInstall = lib.optionalString createSymlinks ''
    mkdir -p $out
    for bin in stash-copy stash-paste wl-copy wl-paste; do
      ln -sf $out/bin/stash $out/bin/$bin
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wayland clipboard manager with fast persistent history and multi-media support";
    homepage = "https://github.com/NotAShelf/stash";
    changelog = "https://github.com/NotAShelf/stash/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      NotAShelf
      fazzi
    ];
    mainProgram = "stash";
  };
})
