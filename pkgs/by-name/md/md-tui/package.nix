{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "md-tui";
  version = "0.11.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "henriklovhaug";
    repo = "md-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e3uCPElgcBtlM0ZBynm38h1hlyCiunHKlvdBFxH3KF8=";
  };

  cargoHash = "sha256-zQm8B8HH+a87YsBd+aSlqX4G8VmwutxJDLj3em1poGI=";

  nativeBuildInputs = [ pkg-config ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Markdown renderer in the terminal";
    homepage = "https://github.com/henriklovhaug/md-tui";
    changelog = "https://github.com/henriklovhaug/md-tui/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      GaetanLepage
      anas
    ];
    platforms = lib.platforms.all;
    mainProgram = "mdt";
  };
})
