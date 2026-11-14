{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  cacert,
  copyDesktopItems,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  wayland,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "playit";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "playit-cloud";
    repo = "playit-agent";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-yAQvEJCIBXgwNg6x1MR5kEPpYgGoiO81RCI+q5fa3/c=";
  };

  cargoHash = "sha256-rK0pBsx9y+jXV2lZJpkwonsKBccl6OEuOeuK2P/fZuA=";

  cargoBuildFlags = [
    "--workspace"
    "--exclude"
    "playitd-tray" # Only works on Windows and macOS
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  buildInputs = [
    libxcb
    libxkbcommon
  ];

  postFixup = ''
    patchelf $out/bin/playit-gui --add-rpath ${
      lib.makeLibraryPath [
        vulkan-loader
        wayland
      ]
    }
  '';

  doCheck = true;
  doInstallCheck = true;

  nativeCheckInputs = [
    cacert
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  preCheck = ''
    # agent_core's TLS tests build a rustls client and fail when the CA store is empty.
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"

    # nixpkgs strips the binaries itself; the manifest's strip setting makes
    # the build and check phases disagree, which causes a rebuild during the check phase.
    export CARGO_PROFILE_RELEASE_STRIP=false
  '';

  desktopItems = [ "linux/gg.playit.gui.desktop" ];
  postInstall = ''
    for size in 32 48 64 128; do
      install -Dm644 "linux/icons/gg.playit.gui-$size.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/gg.playit.gui.png"
    done
  '';

  passthru.tests = {
    inherit (nixosTests) playit;
  };

  meta = {
    mainProgram = "playit-cli";
    description = "Tool to expose game servers running on a local machine to the internet";
    homepage = "https://github.com/playit-cloud/playit-agent";
    changelog = "https://github.com/playit-cloud/playit-agent/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pedorich-n ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
