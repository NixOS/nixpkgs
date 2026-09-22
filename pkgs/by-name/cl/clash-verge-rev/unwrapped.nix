{
  pname,
  version,
  src,
  cargoPatches,
  meta,

  pnpm-hash,
  vendor-hash,

  rustPlatform,
  cargo-tauri,
  autoPatchelfHook,
  jq,
  moreutils,
  nodejs,
  pkg-config,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenv,

  glib,
  kdePackages,
  libayatana-appindicator,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:
rustPlatform.buildRustPackage {
  inherit
    version
    src
    meta
    cargoPatches
    ;
  pname = "${pname}-unwrapped";

  cargoHash = vendor-hash;

  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      ;
    pnpm = pnpm_12;
    fetcherVersion = 4;
    hash = pnpm-hash;
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postPatch = ''
    # We disable the option to try to use the bleeding-edge version of mihomo
    # If you need a newer version, you can override the mihomo input of the wrapped package
    sed -i -e '/Mihomo Alpha/d' ./src/components/setting/mods/clash-core-viewer.tsx

    patch -d $cargoDepsCopy/*/clash_verge_service_ipc-* -p1 < ${./patch-execution-lock.patch}

    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    substituteInPlace $cargoDepsCopy/*/sysproxy-*/src/linux.rs \
      --replace-fail '"gsettings"' '"${glib.bin}/bin/gsettings"' \
      --replace-fail '"kreadconfig6"' '"${kdePackages.kconfig}/bin/kreadconfig6"' \
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

  preBuild = ''
    # tsrs ships a prebuilt binary which still has the traditional Linux
    # interpreter path baked in, so patch it before it is executed by the
    # web build.
    autoPatchelf node_modules/.pnpm/@tsrs+linux-*
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    pkg-config
    pnpmConfigHook
    pnpm_12
  ];

  buildInputs = [
    libayatana-appindicator
    libsoup_3
    openssl
    stdenv.cc.cc.lib
    webkitgtk_4_1
  ];

  # Skip the output scan; tsrs is patched explicitly in preBuild.
  dontAutoPatchelf = true;

  # make sure the .desktop file name does not contain whitespace,
  # so that the service can register it as an auto-start item
  postInstall = ''
    mv $out/share/applications/Clash\ Verge.desktop $out/share/applications/clash-verge.desktop
  '';
}
