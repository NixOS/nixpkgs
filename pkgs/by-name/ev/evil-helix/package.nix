{
  lib,
  fetchFromGitHub,
  helix,
  installShellFiles,
  nix-update-script,
  rustPlatform,
  runCommand,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage (
  finalAttrs:
  let
    defaultRuntimeDir = runCommand "evil-helix-default-runtime" { } ''
      cp -r --no-preserve=mode ${finalAttrs.src}/runtime $out
      rm -rf $out/grammars $out/queries
    '';
  in
  {
    pname = "evil-helix";
    version = "20250915";

    src = fetchFromGitHub {
      owner = "usagi-flow";
      repo = "evil-helix";
      tag = "release-${finalAttrs.version}";
      hash = "sha256-6kqKTZNS1RZwfxcFoa2uC7fUKcQ+KhT5KXusyCt59YQ=";
    };

    cargoHash = "sha256-Mf0nrgMk1MlZkSyUN6mlM5lmTcrOHn3xBNzmVGtApEU=";

    nativeBuildInputs = [
      installShellFiles
      makeBinaryWrapper
    ];

    env = {
      # disable fetching and building of tree-sitter grammars in the helix-term build.rs
      HELIX_DISABLE_AUTO_GRAMMAR_BUILD = "1";
      HELIX_DEFAULT_RUNTIME = defaultRuntimeDir;
    };

    postInstall = ''
      installShellCompletion contrib/completion/hx.{bash,fish,zsh}
      mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
      cp contrib/Helix.desktop $out/share/applications
      cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
      wrapProgram $out/bin/hx --set HELIX_RUNTIME ${helix.runtime}
    '';

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Post-modern modal text editor, with vim keybindings";
      homepage = "https://github.com/usagi-flow/evil-helix";
      license = lib.licenses.mpl20;
      mainProgram = "hx";
      maintainers = with lib.maintainers; [ thiagokokada ];
    };
  }
)
