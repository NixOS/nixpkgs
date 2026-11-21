{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  cmake,
  jq,
  nodejs,
  pkg-config,
  substitute,
  typeshare,
  wrapGAppsHook3,
  yarn-berry_4,
  boost186,
  expat,
  glib-networking,
  gtk3,
  libsodium,
  libsoup_3,
  openssl,
  unbound,
  webkitgtk_4_1,
  zeromq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "eigenwallet";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "eigenwallet";
    repo = "core";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-D1FRp44VKx1PngKFmoVKvoyyQ21cc8oqZxrLtHR5Ikw=";

    # Remove after upstream updates to Yarn 4.15
    # (packageManager in src-gui/package.json)
    postFetch = ''
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry_4.lockfileVersion
          ];
        })
      }
    '';
  };

  cargoPatches = [
    # Use the system CA store instead of compiled-in webpki-roots copies:
    # electrum-client via OpenSSL, tokio-tungstenite via native-tls, and drop
    # unused TLS from bdk 0.28 (electrum) and sqlx (SQLite only).
    # https://github.com/NixOS/nixpkgs/issues/576544
    ./use-system-ca-store.patch
  ];

  patches = [
    ./monero-sys-system-libs.patch
  ];

  postPatch = ''
    # libp2p-websocket has no option for system roots, so read SSL_CERT_FILE
    # or the system bundle instead of webpki-roots
    patch -d "$cargoDepsCopy"/*/libp2p-websocket-* -p1 \
      < ${./libp2p-websocket-system-roots.patch}

    # Apply the patches that monero-sys/build.rs embeds, in the same order
    for p in $(grep -o '"patches/[^"]*\.patch"' monero-sys/build.rs | tr -d '"'); do
      patch -p1 -d monero-sys/monero < monero-sys/$p
    done

    # The frontend is built in preBuild, and updater artifacts need a signing key
    jq '.build.beforeBuildCommand = "" | .bundle.createUpdaterArtifacts = false' \
      src-tauri/tauri.conf.json > tauri.conf.json.new
    mv tauri.conf.json.new src-tauri/tauri.conf.json
  '';

  cargoHash = "sha256-C2N8lcpIcLq/phLbajWJJp7Oefu/mCcP/p/M/TF+foY=";

  missingHashes = ./missing-hashes.json;
  yarnOfflineCache = yarn-berry_4.fetchYarnBerryDeps {
    src = "${finalAttrs.src}/src-gui";
    inherit (finalAttrs) missingHashes;
    hash = "sha256-YUy6khIu8RrbQENErttqxbisIqw7hO3XyPs9rC+oxTk=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    cmake
    jq
    nodejs
    pkg-config
    # FIXME: typeshare's doctests currently fail with the current rustc
    (typeshare.overrideAttrs { doCheck = false; })
    wrapGAppsHook3
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ];

  buildInputs = [
    boost186
    expat
    glib-networking
    gtk3
    libsodium
    libsoup_3
    openssl
    unbound
    webkitgtk_4_1
    zeromq
  ];

  dontUseCmakeConfigure = true;

  dontYarnBerryInstallDeps = true;
  postConfigure = ''
    pushd src-gui
    yarnBerryConfigHook
    popd
  '';

  preBuild = ''
    pushd src-gui
    typeshare --lang=typescript --output-file ./src/models/tauriModel.ts \
      ../swap/src ../monero-rpc-pool/src ../electrum-pool/src ../monero-sys/src \
      ../swap-core/src ../swap-p2p/src ../monero-oxide-ext/src
    yarn run build
    popd
  '';

  buildAndTestSubdir = "src-tauri";

  doCheck = false;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Protocol and desktop application for swapping Monero and Bitcoin";
    homepage = "https://eigenwallet.org";
    changelog = "https://github.com/eigenwallet/core/blob/${finalAttrs.version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [ JacoMalan1 ];
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "unstoppableswap-gui-rs";
  };
})
