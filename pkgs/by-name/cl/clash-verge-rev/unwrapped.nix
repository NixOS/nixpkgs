{
  pname,
  version,
  src,
  meta,

  pnpm-hash,
  vendor-hash,

  rustPlatform,

  cargo-tauri,
  jq,
  moreutils,
  nodejs,
  pkg-config,
  pnpm_9,

  glib,
  kdePackages,
  libayatana-appindicator,
  libsForQt5,
  libsoup,
  openssl,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage {
  inherit version src meta;
  pname = "${pname}-unwrapped";

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = vendor-hash;

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    fetcherVersion = 1;
    hash = pnpm-hash;
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postPatch = ''
    # We disable the option to try to use the bleeding-edge version of mihomo
    # If you need a newer version, you can override the mihomo input of the wrapped package
    sed -i -e '/Mihomo Alpha/d' ./src/components/setting/mods/clash-core-viewer.tsx

    # See service.nix for reasons
    substituteInPlace src-tauri/src/core/service_ipc.rs \
      --replace-fail "/tmp/clash-verge-service.sock" "/run/clash-verge-rev/service.sock"
    # Set verge-mihomo.sock path
    # In service mode, use /run/clash-verge-rev
    # In sidecar mode, use $XDG_RUNTIME_DIR or /run/user/$UID or /tmp
    substituteInPlace src-tauri/src/utils/dirs.rs \
      --replace-fail '"/var/tmp", "/tmp"' '"/run/clash-verge-rev", &std::env::var("XDG_RUNTIME_DIR").unwrap_or_else(|_| std::env::var("UID").map(|uid| format!("/run/user/{}", uid)).unwrap_or_else(|_| "/tmp".to_string()))' \
      --replace-fail 'base_dir.join("verge")' 'base_dir'

    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    substituteInPlace $cargoDepsCopy/sysproxy-*/src/linux.rs \
      --replace-fail '"gsettings"' '"${glib.bin}/bin/gsettings"' \
      --replace-fail '"kreadconfig5"' '"${libsForQt5.kconfig}/bin/kreadconfig5"' \
      --replace-fail '"kreadconfig6"' '"${kdePackages.kconfig}/bin/kreadconfig6"' \
      --replace-fail '"kwriteconfig5"' '"${libsForQt5.kconfig}/bin/kwriteconfig5"' \
      --replace-fail '"kwriteconfig6"' '"${kdePackages.kconfig}/bin/kwriteconfig6"'

    # this file tries to override the linker used when compiling for certain platforms
    rm .cargo/config.toml

    # disable updater and don't try to bundle helper binaries
    jq '
      .bundle.createUpdaterArtifacts = false |
      del(.bundle.resources) |
      del(.bundle.externalBin)
    ' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json

    jq 'del(.bundle.externalBin)' src-tauri/tauri.linux.conf.json | sponge src-tauri/tauri.linux.conf.json

    # As a side effect of patching the service to fix the arbitrary file overwrite issue,
    # we also need to update the timestamp format in the filename to the second level.
    # This ensures that the Clash kernel can still be restarted within one minute without problems.
    substituteInPlace src-tauri/src/utils/dirs.rs \
      --replace-fail '%Y-%m-%d-%H%M' '%Y-%m-%d-%H%M%S'
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    pkg-config
    pnpm_9.configHook
  ];

  buildInputs = [
    libayatana-appindicator
    libsoup
    openssl
    webkitgtk_4_1
  ];

  # make sure the .desktop file name does not contain whitespace,
  # so that the service can register it as an auto-start item
  postInstall = ''
    mv $out/share/applications/Clash\ Verge.desktop $out/share/applications/clash-verge.desktop
  '';
}
