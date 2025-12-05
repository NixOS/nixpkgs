{
  pname,
  version,
  src,
  meta,

  pnpm-hash,
  vendor-hash,

  rustPlatform,
  fetchpatch,

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

  patches = [
    (fetchpatch {
      url = "https://github.com/clash-verge-rev/clash-verge-rev/commit/645b92bc2815fe55bbc827907bff0edbfee48674.patch";
      hash = "sha256-BH0SvVofW6YJ3e/LOHojisenMwcxYfm3gG/dbxvYBMs=";
    })
  ];

  postPatch = ''
    # We disable the option to try to use the bleeding-edge version of mihomo
    # If you need a newer version, you can override the mihomo input of the wrapped package
    sed -i -e '/Mihomo Alpha/d' ./src/components/setting/mods/clash-core-viewer.tsx

    # Set service.sock path
    substituteInPlace $cargoDepsCopy/clash_verge_service_ipc-*/src/lib.rs \
      --replace-fail "/tmp/verge/clash-verge-service.sock" "/run/clash-verge-rev/service.sock"
    # Set verge-mihomo.sock path
    substituteInPlace src-tauri/src/utils/dirs.rs \
      --replace-fail 'once("/tmp")' 'once(&std::env::var("XDG_RUNTIME_DIR").unwrap_or_else(|_| std::env::var("UID").map(|uid| format!("/run/user/{}", uid)).unwrap_or_else(|_| "/tmp".to_string())))' \
      --replace-fail 'join("verge")' 'join("clash-verge-rev")'

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
