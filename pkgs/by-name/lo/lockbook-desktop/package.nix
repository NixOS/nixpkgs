{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  glib,
  gobject-introspection,
  gdk-pixbuf,
  libxkbcommon,
  vulkan-loader,
  makeDesktopItem,
  autoPatchelfHook,
  copyDesktopItems,
}:
let
  desc = "Private, polished note-taking platform";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lockbook-desktop";
  version = "26.10.15";

  src = fetchFromGitHub {
    owner = "lockbook";
    repo = "lockbook";
    tag = finalAttrs.version;
    hash = "sha256-oJsVqsDA1aAsosBXQukZlwb2TSiThFf2HFuNIW4/YJo=";
  };

  cargoHash = "sha256-HJfaB4XsED1V7JI0z3QWdQvTq2VdY+DoOH2yI6h/jlo=";

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    glib
    gobject-introspection
    gdk-pixbuf
  ];

  runtimeDependencies = [
    vulkan-loader
    libxkbcommon
  ];

  doCheck = false; # there are no cli tests
  cargoBuildFlags = [
    "--package"
    "lockbook-desktop"
  ];

  desktopItems = makeDesktopItem {
    desktopName = "Lockbook";
    name = "lockbook-desktop";
    comment = desc;
    icon = "lockbook";
    exec = "lockbook-desktop";
    categories = [
      "Office"
      "Documentation"
      "Utility"
    ];
  };

  postInstall = ''
    install -D docs/graphics/logo.svg $out/share/icons/hicolor/scalable/apps/lockbook.svg
    install -Dm644 utils/dev/flatpak-package/net.lockbook.Lockbook.appdata.xml -t $out/share/metainfo
  '';

  meta = {
    description = desc;
    longDescription = ''
      Write notes, sketch ideas, and store files in one secure place.
      Share seamlessly, keep data synced, and access it on any
      platform—even offline. Lockbook encrypts files so even we
      can’t see them, but don’t take our word for it:
      Lockbook is 100% open-source.
    '';
    homepage = "https://lockbook.net";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.linux;
    changelog = "https://github.com/lockbook/lockbook/releases/tag/${finalAttrs.version}";
    maintainers = [ lib.maintainers.parth ];
  };
})
