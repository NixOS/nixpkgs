{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  wrapGAppsHook4,
  appstream,
  desktop-file-utils,
  glib,
  gtk4,
  libadwaita,
  gdk-pixbuf,
  librsvg,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "carmenta";
  version = "0.8.0-unstable-2026-07-30";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "szymonwilczek";
    repo = "carmenta";
    rev = "94e9f3c28dd820eec49a30fe4e95484eac51fb6b";
    hash = "sha256-nIOhzWEHgg04YoWRNocPkmE1ozVmZbAAfQFBxw0BsvE=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapGAppsHook4
    appstream
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gdk-pixbuf
    librsvg
  ];

  env.AWS_LC_SYS_CMAKE_BUILDER = 1;

  postInstall = ''
    install -Dm644 data/io.github.szymonwilczek.carmenta.desktop -t $out/share/applications
    install -Dm644 data/io.github.szymonwilczek.carmenta.metainfo.xml -t $out/share/metainfo
    install -Dm644 data/io.github.szymonwilczek.carmenta.svg \
      $out/share/icons/hicolor/scalable/apps/io.github.szymonwilczek.carmenta.svg
  '';

  doInstallCheck = true;
  postInstallCheck = ''
    desktop-file-validate $out/share/applications/io.github.szymonwilczek.carmenta.desktop
    appstreamcli validate --no-net $out/share/metainfo/io.github.szymonwilczek.carmenta.metainfo.xml

    "$out/bin/carmenta" --help > /dev/null
    versionOutput=$("$out/bin/carmenta" --version)
    echo "carmenta --version reported: $versionOutput"
    [ "$versionOutput" = "carmenta ${lib.head (lib.splitString "-unstable-" finalAttrs.version)}" ]
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--generate-lockfile"
    ];
  };

  meta = {
    description = "Blazing fast Emoji Picker";
    homepage = "https://github.com/szymonwilczek/carmenta";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaravrav ];
    mainProgram = "carmenta";
    platforms = lib.platforms.linux;
  };
})
