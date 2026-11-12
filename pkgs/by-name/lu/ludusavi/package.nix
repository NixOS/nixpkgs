{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  cmake,
  pkg-config,
  makeWrapper,
  wrapGAppsHook3,
  bzip2,
  libGL,
  libx11,
  libxkbcommon,
  libxcursor,
  libxi,
  libxcb,
  vulkan-loader,
  wayland,
  gtk3,
  glib,
  rclone,
  sqlite,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ludusavi";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "ludusavi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S2yN0WLG2tUxkqR9xe466VE+QgDQcSNgyNjvjTjTY7Q=";
  };

  cargoHash = "sha256-nRqyzRl10xRMLR5hxSaaMxBArgScoV2/iCvMkN9zH/4=";

  dontWrapGApps = true;

  nativeBuildInputs = [
    cmake
    installShellFiles
    pkg-config
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    bzip2
    glib
    sqlite
    zstd
  ];

  postInstall = ''
    install -Dm644 assets/linux/com.mtkennerly.ludusavi.metainfo.xml -t \
      "$out/share/metainfo/"
    install -Dm644 assets/icon.png \
      "$out/share/icons/hicolor/64x64/apps/com.mtkennerly.ludusavi.png"
    install -Dm644 assets/icon.svg \
      "$out/share/icons/hicolor/scalable/apps/com.mtkennerly.ludusavi.svg"
    install -Dm644 "assets/linux/com.mtkennerly.ludusavi.desktop" -t "$out/share/applications/"
    install -Dm644 LICENSE -t "$out/share/licenses/ludusavi/"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ludusavi \
      --bash <($out/bin/ludusavi complete bash) \
      --fish <($out/bin/ludusavi complete fish) \
      --zsh <($out/bin/ludusavi complete zsh)
  '';

  postFixup =
    let
      libPath = lib.makeLibraryPath [
        libGL
        vulkan-loader
        libx11
        libxkbcommon
        wayland
        libxcursor
        libxi
        libxcb
      ];
    in
    ''
      patchelf --add-rpath "${libPath}" "$out/bin/ludusavi"
      wrapProgram $out/bin/ludusavi --prefix PATH : ${lib.makeBinPath [ rclone ]} "''${gappsWrapperArgs[@]}"
    '';

  meta = {
    description = "Backup tool for PC game saves";
    homepage = "https://github.com/mtkennerly/ludusavi";
    changelog = "https://github.com/mtkennerly/ludusavi/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pasqui23
      megheaiulian
    ];
    mainProgram = "ludusavi";
  };
})
