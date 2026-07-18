{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghost-complete";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "StanMarek";
    repo = "ghost-complete";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AOhH98qGHISf8AZw3MSMnS5ADL6wQJ5jlo4PXsw7CAo=";
  };

  __structuredAttrs = true;

  # Upstream hardcodes `-fuse-ld=/usr/bin/ld` for darwin targets, which the
  # Nix clang wrapper rejects ("invalid linker name"). Drop the flag and let
  # the wrapper pick the right linker.
  postPatch = ''
    substituteInPlace .cargo/config.toml \
      --replace-fail '"-C", "link-arg=-fuse-ld=/usr/bin/ld",' ""
  '';

  cargoHash = "sha256-l1Gp9FVtrGhzobM2Wdq110y1W7V6PNsQsJLBJ3sgOEs=";

  cargoBuildFlags = [ "--package=ghost-complete" ];

  # Integration tests in crates/ghost-complete/tests/smoke.rs spawn a real
  # PTY + shell and exercise terminal I/O, which isn't available in the
  # Nix build sandbox.
  doCheck = false;

  # `ghost-complete install` imperatively copies these scripts into the
  # user's `~/.config/ghost-complete/shell/` and edits `~/.zshrc` to source
  # them. In a Nix world we instead expose them here so users can source
  # them declaratively from their shell configuration (e.g. home-manager
  # `programs.zsh.initContent` or NixOS `programs.zsh.interactiveShellInit`).
  # The 709 completion specs are already embedded in the binary and used
  # as an automatic fallback when no on-disk spec directory is present, so
  # they don't need to be copied out.
  postInstall = ''
    install -Dm644 -t $out/share/ghost-complete/shell \
      shell/init.zsh \
      shell/ghost-complete.zsh \
      shell/ghost-complete.bash \
      shell/ghost-complete.fish
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-native autocomplete engine using PTY proxying for macOS terminals";
    homepage = "https://github.com/StanMarek/ghost-complete";
    changelog = "https://github.com/StanMarek/ghost-complete/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imcvampire ];
    mainProgram = "ghost-complete";
    platforms = lib.platforms.darwin;
  };
})
