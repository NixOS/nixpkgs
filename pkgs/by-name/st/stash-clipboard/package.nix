{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stash-clipboard";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "NotAShelf";
    repo = "stash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L5UfPKzdU8qQIyXSCMglLhv22J7xInxg3NNKCLkxszM=";
  };

  cargoHash = "sha256-iXL3G1H8tNS1oPAoEvvx7qwWUef95NBU3dwlEe+34zw=";

  __structuredAttrs = true;

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
