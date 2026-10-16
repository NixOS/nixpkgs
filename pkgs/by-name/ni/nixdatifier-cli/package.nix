{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  bash,
  nix-update-script,
  jq,
  git,
  curl,
  coreutils,
  util-linux,
  findutils,
  gnugrep,
  gnused,
  gawk,
  libnotify,
  direnv,
  fzf,
  chafa,
}:

let
  runtime = [
    bash
    jq
    git
    curl
    coreutils
    util-linux
    findutils
    gnugrep
    gnused
    gawk
    libnotify
    direnv
    fzf
    chafa
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nixdatifier-cli";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "Muddyblack";
    repo = "nixdatifier";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ALm8Cp7vxlpx3VdT5HgIaoPnD42C86u7SVppFpxi8o=";
  };

  sourceRoot = "${finalAttrs.src.name}/package";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  # patchShebangs of the shell helpers
  buildInputs = [ bash ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    dest="$out/share/nixdatifier/package"
    mkdir -p "$dest/contents" "$out/bin"
    cp metadata.json icon-emblem.png icon-emblem.svg "$dest/"
    install -Dm644 icon-emblem.svg "$out/share/icons/hicolor/scalable/apps/nixdatifier.svg"
    cp -r contents/tools contents/code contents/icons "$dest/contents/"
    for shell in bash zsh fish; do
      ${lib.getExe bash} contents/tools/sh/nixdatifier completion $shell > nixdatifier.$shell
    done
    installShellCompletion --cmd nixdatifier \
      --bash nixdatifier.bash --zsh nixdatifier.zsh --fish nixdatifier.fish
    # Appended, so the nix and sudo already on the system always win.
    for helper in "$dest"/contents/tools/sh/*; do
      if [[ -x "$helper" ]]; then
        wrapProgram "$helper" --suffix PATH : ${lib.makeBinPath runtime}
      fi
    done
    ln -s "$dest/contents/tools/sh/nixdatifier" "$out/bin/nixdatifier"
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nixdatifier --version
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line and terminal view for NixOS generations, flake updates, cleanup and dev environments";
    homepage = "https://github.com/Muddyblack/nixdatifier";
    changelog = "https://github.com/Muddyblack/nixdatifier/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "nixdatifier";
    maintainers = with lib.maintainers; [ muddyblack ];
    # Both packages install bin/nixdatifier; lose the conflict to the window app.
    priority = 10;
  };
})
