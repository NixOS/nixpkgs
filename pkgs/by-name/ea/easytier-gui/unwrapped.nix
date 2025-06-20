{
  pname,
  version,
  src,
  meta,
  pnpm-hash,
  vendor-hash,
  rustPlatform,
  cargo-tauri,
  nodejs,
  pkg-config,
  pnpm_9,
  protobuf,
  llvmPackages,
  libayatana-appindicator,
  libsoup_2_4,
  openssl,
  webkitgtk_4_1,
}:
rustPlatform.buildRustPackage {
  inherit version src meta;
  pname = "${pname}-unwrapped";

  cargoRoot = ".";
  buildAndTestSubdir = "easytier-gui/src-tauri";

  useFetchCargoVendor = true;
  cargoHash = vendor-hash;

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = pnpm-hash;
  };

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"

    # Update the build command of Tauri in pnpm workspace to recursively build
    substituteInPlace easytier-gui/src-tauri/tauri.conf.json \
      --replace-fail "pnpm build" "pnpm -r build"

    # this file tries to override the linker used when compiling for certain platforms
    rm .cargo/config.toml
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    pkg-config
    pnpm_9.configHook
    llvmPackages.libclang
    protobuf
    rustPlatform.bindgenHook
  ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  doCheck = false; # tests failed due to heavy rely on network

  buildInputs = [
    libayatana-appindicator
    libsoup_2_4
    openssl
    webkitgtk_4_1
  ];
}
