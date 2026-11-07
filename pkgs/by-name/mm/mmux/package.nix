{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  gitMinimal,
  tmux,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mmux";
  version = "0.13.18";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "marvinvr";
    repo = "mmux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oMpnFA6BgYadhWrS/gPuJQcrVt8lhrmP7RNJNTMFQ8c=";
  };

  cargoHash = "sha256-P4y0lBRSuULa5ieFet9si5Ugi6/g2U6f5cfCbW2BgFo=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  nativeCheckInputs = [ gitMinimal ];

  # mmux runs everything inside a tmux session and shells out to git for its
  # git panel. Suffix so a tmux/git already on the user's PATH takes precedence.
  postInstall = ''
    wrapProgram $out/bin/mmux \
      --suffix PATH : ${
        lib.makeBinPath [
          gitMinimal
          tmux
        ]
      }
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Persistent terminal multiplexer for AI coding agents and dev processes";
    homepage = "https://mmux.org";
    changelog = "https://github.com/marvinvr/mmux/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ marvinvr ];
    mainProgram = "mmux";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
