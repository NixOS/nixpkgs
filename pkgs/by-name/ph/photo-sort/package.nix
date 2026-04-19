{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  nix-update-script,
  ffmpeg,
  installShellFiles,

  withVideoSupport ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "photo-sort";
  version = "0.3.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "0xCCF4";
    repo = "PhotoSort";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1YG0bEhXLhosgmuyJtOAOn4GMHVwCayLR2xtxLi7rnw=";
  };

  cargoHash = "sha256-LL2oUN08YQiRKRebmggjLrgofYNmj4HQi5PB83YJuIo=";

  cargoBuildFlags = lib.optional withVideoSupport "--features=video";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optional withVideoSupport ffmpeg.dev;

  postInstall = ''
    mv $out/bin/photo_sort $out/bin/photo-sort || true
    BIN=$out/bin/photo-sort

    mkdir -p man
    BUILD_MANPAGE=man $BIN

    mkdir -p completions
    BUILD_SHELL=bash $BIN > completions/photo-sort.bash
    BUILD_SHELL=fish $BIN > completions/photo-sort.fish
    BUILD_SHELL=zsh $BIN > completions/_photo-sort

    installShellCompletion --cmd photo-sort \
      --bash completions/photo-sort.bash \
      --fish completions/photo-sort.fish \
      --zsh completions/_photo-sort

    installManPage man/*
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A tool to rename/move/copy/hardlink/symlink and sort photos/videos by its EXIF date/metadata.";
    homepage = "https://github.com/0xCCF4/PhotoSort";
    changelog = "https://github.com/0xCCF4/PhotoSort/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ _0xCCF4 ];
    mainProgram = "photo-sort";
  };
})
