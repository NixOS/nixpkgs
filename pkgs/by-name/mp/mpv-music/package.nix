{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  mpv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mpv-music";
  version = "0.29.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FurqanHun";
    repo = "mpv-music";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G0DUJzLi3LcigfVQuJ4E/tOj4EgK0DG2zMSh+Qnf2Aw=";
  };

  cargoHash = "sha256-h0/ZgKqM9AUEySpMcahDB0TJYGG079Akj4qTpLxVfzk=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ mpv ];

  # These two tests isolate via XDG env vars, which the `directories` crate
  # ignores on Darwin (paths are derived from $HOME/Library), so they fail there.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=test_user_flow_isolated_config_removal"
    "--skip=test_user_flow_isolated_log_deletion"
  ];

  postInstall = ''
    wrapProgram $out/bin/mpv-music \
      --prefix PATH : ${lib.makeBinPath [ mpv ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A blazing-fast terminal music player and mpv-based music library browser with fuzzy search, metadata previews, and zero background daemons";
    homepage = "https://github.com/FurqanHun/mpv-music";
    changelog = "https://github.com/FurqanHun/mpv-music/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arison ];
    mainProgram = "mpv-music";
  };
})
