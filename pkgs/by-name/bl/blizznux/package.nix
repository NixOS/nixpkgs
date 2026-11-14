{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  glib-networking,
  webkitgtk_4_1,
  curl,
  umu-launcher,
  xz,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "blizznux";
  version = "0.2.44";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlizzNux";
    repo = "launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NLtnf45Ac/Ix4dcJBGNY2i088fK8ioHXVngmmAMvEy0=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-UXwhzI/E+PLfnbz/EIwivlJ6ECO+7uX7+9rTsPB5C+g=";

  # The UI is static (ui/), so the Tauri binary is the only build product.
  # `cargo tauri build` would only add this feature and a .deb.
  buildFeatures = [ "tauri/custom-protocol" ];

  # Upstream downloads a umu-launcher zipapp at runtime, which cannot start
  # its Steam Runtime container on NixOS. Use the packaged one, the same
  # release, the way the Flatpak uses its bundled copy. The readiness check
  # also looks for Vulkan drivers where NixOS puts them.
  postPatch = ''
    substituteInPlace bin/blizznux-run \
      --replace-fail 'if [[ -n ''${FLATPAK_ID:-} && -x /app/bin/umu-run ]]; then echo /app/bin/umu-run; return; fi' \
        'echo ${lib.getExe umu-launcher}; return'
    substituteInPlace src-tauri/src/lib.rs \
      --replace-fail '"/app/bin/umu-run"' '"${lib.getExe umu-launcher}"' \
      --replace-fail 'std::env::var_os("FLATPAK_ID").is_some() && bundled.is_file()' 'bundled.is_file()' \
      --replace-fail '"/usr/local/share/vulkan/icd.d"]' \
        '"/usr/local/share/vulkan/icd.d", "/run/opengl-driver/share/vulkan/icd.d", "/run/opengl-driver-32/share/vulkan/icd.d"]' \
      --replace-fail '"/usr/lib/libGLX_nvidia.so.0",' \
        '"/usr/lib/libGLX_nvidia.so.0", "/run/opengl-driver-32/lib/libGLX_nvidia.so.0",'
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking
    webkitgtk_4_1
  ];

  # The app finds `blizznux-run` next to its own binary.
  postInstall = ''
    install -Dm755 bin/blizznux-run -t $out/bin
    install -Dm644 share/applications/com.blizznux.launcher.desktop -t $out/share/applications
    cp -r share/icons $out/share
  '';

  # What the upstream deb and rpm depend on, minus the zipapp's python3.
  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        curl
        xz
      ]
    })
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Install and launch Battle.net games through Proton, without Steam";
    homepage = "https://github.com/BlizzNux/launcher";
    changelog = "https://github.com/BlizzNux/launcher/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ caniko ];
    mainProgram = "blizznux";
    platforms = [ "x86_64-linux" ];
  };
})
