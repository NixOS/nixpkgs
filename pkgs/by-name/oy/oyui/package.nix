{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "oyui";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "emilien-jegou";
    repo = "oyui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z69mBOZFHqslZLC2WutvkhcydxAmO9pppapJSTeHtiA=";
  };

  cargoHash = "sha256-3XzTbrEDFzCf2rsvJu/foiDYEoO4lLMsr+4t9nDYv34=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern TUI merge tool and interactive diff editor for Jujutsu (jj) and Git";
    homepage = "https://github.com/emilien-jegou/oyui";
    changelog = "https://github.com/emilien-jegou/oyui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      adda
    ];
    mainProgram = "oyui";
  };
})
