{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,

  pkg-config,
  libsoup_3,
  glib,
  gtk3,
  webkitgtk_4_1,
  xdotool,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-packager";
  version = "0.11.5";

  src = fetchFromGitHub {
    owner = "crabnebula-dev";
    repo = "cargo-packager";
    tag = "cargo-packager-v${finalAttrs.version}";
    hash = "sha256-qCecd4IoDn+UpRm+0yCFpN7rj68pZD85xGYudjCB+hM=";
  };

  cargoHash = "sha256-YKnQQ60N4Zxud9ZMqcKpQJ1l5txR8jaxLi5XFY3Buew=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libsoup_3
    glib
    gtk3
    webkitgtk_4_1
    xdotool
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "cargo-packager-v(.*)"
    ];
  };

  meta = {
    description = "Rust executable packager, bundler and updater";
    mainProgram = "cargo-packager";
    homepage = "https://github.com/crabnebula-dev/cargo-packager";
    changelog = "https://github.com/crabnebula-dev/cargo-packager/releases/tag/cargo-packager-v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ haruki7049 ];
  };
})
