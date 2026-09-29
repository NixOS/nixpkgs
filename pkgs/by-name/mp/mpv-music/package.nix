{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  mpv,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mpv-music";
  version = "0.29.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FurqanHun";
    repo = "mpv-music";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kqo14AoWNlonST6a7kRw2q8Lz9BrRtm+PTDNYre4rRI=";
  };

  cargoHash = "sha256-0xypsLjLjJgJ9OPaPlMUE+6TVuJLCj6mR+pwqyoeXYw=";

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ mpv ];

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
