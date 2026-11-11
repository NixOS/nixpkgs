{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  createSymlinks ? true,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stash-clipboard";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "stash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bHaOGQrF472K98Styymc3NUTrSgDAdWhL01K0wkhRl0=";
  };

  cargoHash = "sha256-8xQ501X4AJrsZN/jnG/mSRZp4JTcaFxSYM3TeWfDhQ8=";

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
