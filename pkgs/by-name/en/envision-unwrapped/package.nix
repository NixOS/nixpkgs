{
  appstream-glib,
  applyPatches,
  cairo,
  cargo,
  desktop-file-utils,
  fetchFromGitLab,
  gdb,
  gdk-pixbuf,
  git,
  glib,
  gtk4,
  gtksourceview5,
  lib,
  libadwaita,
  libgit2,
  libusb1,
  meson,
  ninja,
  nix-update-script,
  openssl,
  openxr-loader,
  pango,
  pkg-config,
  rustPlatform,
  rustc,
  stdenv,
  vte-gtk4,
  versionCheckHook,
  wrapGAppsHook4,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "envision-unwrapped";
  version = "2.0.1";

  src = fetchFromGitLab {
    owner = "gabmus";
    repo = "envision";
    rev = finalAttrs.version;
    hash = "sha256-J1zctfFOyu+uLpctTiAe5OWBM7nXanzQocTGs1ToUMA=";
  };

  patches = [
    ./support-headless-cli.patch
  ];

  strictDeps = true;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version;
    # TODO: Use srcOnly instead
    src = applyPatches {
      inherit (finalAttrs) src patches;
    };
    hash = "sha256-O3+urY2FlnHfxoJLn4iehnVWf1Y0uATEteyQVnZLxTQ=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    cargo
    git
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    gtksourceview5
    libadwaita
    libgit2
    libusb1
    openssl
    openxr-loader
    pango
    vte-gtk4
    zlib
  ];

  # FIXME: error when running `env -i envision`:
  # "HOME env var not defined: NotPresent"
  doInstallCheck = false;
  versionCheckProgram = "${placeholder "out"}/bin/envision";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  postInstall = ''
    wrapProgram $out/bin/envision \
      --prefix PATH : "${lib.makeBinPath [ gdb ]}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UI for building, configuring and running Monado, the open source OpenXR runtime";
    homepage = "https://gitlab.com/gabmus/envision";
    license = lib.licenses.agpl3Only;
    mainProgram = "envision";
    # More maintainers needed!
    # envision (wrapped) requires frequent updates to the dependency list;
    # the more people that can help with this, the better.
    maintainers = with lib.maintainers; [
      pandapip1
      Scrumplex
      txkyel
    ];
    platforms = lib.platforms.linux;
  };
})
