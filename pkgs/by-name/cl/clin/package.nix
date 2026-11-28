{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  zlib,
  libgit2,
  libx11,
  libxcb,
  installShellFiles,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clin";
  version = "0.9.9";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "reekta92";
    repo = "clin-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1WrhXeKvxnBcBP8WJHKxLrgQ/FtsLrlBmhuU8McYbmg=";
  };

  cargoHash = "sha256-Lm5B6rjZy9mgCME+iFQlR62dqpP93+3Ds69LEFirouE=";
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    openssl
    zlib
    libgit2
    libx11
    libxcb
  ];

  postInstall = "install -Dm444 assets/clin.desktop -t $out/share/applications";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-packed TUI note management app inspired by Obsidian";
    longDescription = ''
      clin is a free, open-source terminal note manager inspired by Obsidian.
      It packs Obsidian's core features — markdown editing and rendering, .canvas
      files, and a force-directed graph view — into a roughly 2-5 MB Rust binary with
      minimal resource use, while keeping the UI approachable.
    '';
    homepage = "https://github.com/reekta92/clin-rs/tree/main";
    license = lib.licenses.gpl3;
    mainProgram = "clin";
    maintainers = with lib.maintainers; [ louis-thevenet ];
  };
})
