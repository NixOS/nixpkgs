{
  lib,
  rustPlatform,
  fetchFromGitHub,
  wrapGAppsHook4,
  pkg-config,
  gtk4,
  libadwaita,
  gettext,
  parted,
  e2fsprogs,
  util-linux,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nix-disk";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "nix-disk";
    rev = "fc2db0e262f094fb9aa976e9d2838419e0a70c1b";
    hash = "sha256-v1h7HdJFN0gXRMjjRWEDihhycco+7/V6c6xTsxh51eI=";
  };

  cargoHash = "sha256-jqe5Sa89tKdD4aLNiOFz/272cCFXRRStvr5F5FXSzZc=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    gettext
  ];

  buildInputs = [
    gtk4
    libadwaita
  ];

  postInstall = ''
    # Install icons
    for size in 16 32 48 64 128 256 512; do
      install -Dm644 data/icons/nix-disk-''${size}x''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/nix-disk.png
    done

    # Install desktop file
    install -Dm644 data/nix-disk.desktop.in $out/share/applications/nix-disk.desktop

    # Install polkit policy
    install -Dm644 data/org.glfos.nixdiskmanager.in \
      $out/share/polkit-1/actions/org.glfos.nixdiskmanager.policy

    # Compile and install translations
    for po in po/*.po; do
      lang=$(basename "$po" .po)
      mkdir -p $out/share/locale/$lang/LC_MESSAGES
      msgfmt -o $out/share/locale/$lang/LC_MESSAGES/nix-disk.mo "$po"
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${
        lib.makeBinPath [
          parted
          e2fsprogs
          util-linux
        ]
      }"
    )
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern GTK4/Libadwaita GUI for managing disk mount configurations on NixOS";
    homepage = "https://github.com/liberodark/nix-disk";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "nix-disk";
  };
})
