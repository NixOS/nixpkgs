{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  createSymlinks ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stash-clipboard";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "stash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G31RXNllgbC5SqRMVj5L9/hCpsKuK/s4Byq+TT8a7X4=";
  };

  cargoHash = "sha256-biKZ2qIAiNuvEuI8cJV2zuRXusuUlkd8MKq/M9J+FJs=";

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
