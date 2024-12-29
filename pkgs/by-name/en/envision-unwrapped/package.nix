{
  lib,
  stdenv,
  fetchFromGitLab,
  writeScript,
  appstream-glib,
  cargo,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  desktop-file-utils,
  gdb,
  gdk-pixbuf,
  glib,
  gtk4,
  gtksourceview5,
  libadwaita,
  libgit2,
  libusb1,
  openssl,
  pango,
  vte-gtk4,
  zlib,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "envision-unwrapped";
  version = "0-unstable-2024-07-03";

  src = fetchFromGitLab {
    owner = "gabmus";
    repo = "envision";
    rev = "6cf5e40b96d1cbd99a3cfcef1f03899356e79448";
    hash = "sha256-a/IUNGoq9OKEC3uCg6PUp2TRHkfm4mTT3QQ8SfA29RU=";
  };

  strictDeps = true;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "libmonado-rs-0.1.0" = "sha256-PsNgfpgso3HhIMXKky/u6Xw8phk1isRpNXKLhvN1wIE=";
    };
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    cargo
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
    pango
    vte-gtk4
    zlib
  ];

  postInstall = ''
    wrapProgram $out/bin/envision \
      --prefix PATH : "${lib.makeBinPath [ gdb ]}"
  '';

  passthru.updateScript = writeScript "envision-update" ''
    source ${builtins.head (unstableGitUpdater { })}

    cp $tmpdir/Cargo.lock ./pkgs/by-name/en/envision-unwrapped/Cargo.lock
  '';

  meta = {
    description = "UI for building, configuring and running Monado, the open source OpenXR runtime";
    homepage = "https://gitlab.com/gabmus/envision";
    license = lib.licenses.agpl3Only;
    mainProgram = "envision";
    maintainers = with lib.maintainers; [
      pandapip1
      Scrumplex
    ];
    platforms = lib.platforms.linux;
  };
})
