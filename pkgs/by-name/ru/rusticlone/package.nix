{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  rustic,
  rclone,
  tzdata,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rusticlone";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "AlphaJack";
    repo = "rusticlone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dxclPlqDYamlm/9q3yBAFzKC2ZReJY+Sr0h6JqZ3jr4=";
  };

  cargoHash = "sha256-BtHjckt8zH3pyeDTCb6P+4Jb8KdF/zzJYW6CRJRu/R0=";

  # the default self-update feature would replace the binary in the store
  buildNoDefaultFeatures = true;
  buildFeatures = [ "desktop" ];

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];

  useNextest = true;
  cargoTestFlags = [ "--lib" ];
  preCheck = ''
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  # rusticlone runs rustic, and rustic runs rclone for rclone: repositories
  postInstall = ''
    wrapProgram $out/bin/rusticlone --prefix PATH : ${
      lib.makeBinPath [
        rustic
        rclone
      ]
    }
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    for dir in system user; do
      install -Dm644 packaging/linux/rusticlone.service $out/lib/systemd/$dir/rusticlone.service
      substituteInPlace $out/lib/systemd/$dir/rusticlone.service \
        --replace-fail "ExecStart=%N" "ExecStart=$out/bin/rusticlone"
    done
    install -Dm644 packaging/linux/rusticlone.desktop -t $out/share/applications
    install -Dm644 assets/images/logo.svg $out/share/icons/hicolor/scalable/apps/rusticlone.svg
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rusticlone \
      --bash <(COMPLETE=bash $out/bin/rusticlone) \
      --zsh <(COMPLETE=zsh $out/bin/rusticlone) \
      --fish <(COMPLETE=fish $out/bin/rusticlone)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scheduled 3-2-1-1-0 backups built on rustic profiles, with a web UI and notifications";
    homepage = "https://github.com/AlphaJack/rusticlone";
    changelog = "https://github.com/AlphaJack/rusticlone/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ alphajack ];
    mainProgram = "rusticlone";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
