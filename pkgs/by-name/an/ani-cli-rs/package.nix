{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  syncplay,
  aria2,
  mpv,
  vlc,
  iina,
  withMpv ? true,
  withVlc ? false,
  withIina ? false,
  syncSupport ? false,
}:
let
  players = lib.optional withMpv mpv ++ lib.optional withVlc vlc ++ lib.optional withIina iina;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ani-cli-rs";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "vorlie";
    repo = "ani-cli-rs";
    tag = finalAttrs.version;
    hash = "sha256-t7xyuXjJUKPtmY+pxFe/rVRvRpET9dh8ZBLqI1LkcGo=";
  };

  cargoHash = "sha256-HxWftqADCCSxvuUNu95iUN8dN0mlx9g+GBE1IeJdLOg=";

  checkType = "debug";

  nativeBuildInputs = [ makeWrapper ];
  runtimeInputs = [
    aria2
  ]
  ++ lib.optional syncSupport syncplay;

  postInstall = ''
    wrapProgram $out/bin/ani-cli-rs \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeInputs} \
      ${lib.optionalString (builtins.length players > 0) "--suffix PATH : ${lib.makeBinPath players}"}
  '';

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A cross-platform Rust port of ani-cli focused on the current AllAnime workflow";
    homepage = "https://github.com/vorlie/ani-cli-rs";
    license = lib.licenses.gpl3Only;
    changelog = "https://github.com/vorlie/ani-cli-rs/blob/${finalAttrs.version}/release-notes.md";
    mainProgram = "ani-cli-rs";
    maintainers = with lib.maintainers; [ kuflierl ];
  };
})
