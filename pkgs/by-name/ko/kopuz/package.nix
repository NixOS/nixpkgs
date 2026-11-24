{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
  callPackage,
  pkg-config,
  cmake,
  git,
  makeWrapper,
  aws-lc,
  openssl,
  cacert,
  alsa-lib,
  libopus,
  sqlite,
  rust-jemalloc-sys,
  wayland,
  vulkan-loader,
  libxcb,
  libxkbcommon,
  libx11,
  fontconfig,
  freetype,
  ffmpeg,
  libcdio,
  libcdio-paranoia,
}:

let
  rustyV8Version = "130.0.7";
  rustyV8Target = stdenv.hostPlatform.rust.rustcTarget;
  rustyV8Hashes = {
    "aarch64-unknown-linux-gnu" = "sha256-vu/ns1q+53FZ98tVCWZmsHYwwRBH1fOnTdBlhjcpkVo=";
    "x86_64-unknown-linux-gnu" = "sha256-pkdsuU6bAkcIHEZUJOt5PXdzK424CEgTLXjLtQ80t10=";
  };
  librustyV8 = fetchurl {
    url = "https://github.com/denoland/rusty_v8/releases/download/v${rustyV8Version}/librusty_v8_release_${rustyV8Target}.a.gz";
    hash = rustyV8Hashes.${rustyV8Target};
  };

  gpuiLibs = [
    wayland
    vulkan-loader
    libxcb
    libxkbcommon
    libx11
    fontconfig
    freetype
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kopuz";
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Kopuz-org";
    repo = "kopuz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nJbTWXZQCs5Ps5BWPL7qVHJMhJYbU3DVIz/7Kgr2TBs=";
  };

  cargoHash = "sha256-GSuWtlZNKgywPWf2WEk9NNCmIrr2R8LV0qUAi8SLskI=";

  postPatch = ''
    substituteInPlace $cargoDepsCopy/*/sqlx-sqlite-*/src/connection/establish.rs \
      --replace-fail 'flags |= SQLITE_OPEN_MEMORY;' 'flags |= SQLITE_OPEN_MEMORY | libsqlite3_sys::SQLITE_OPEN_URI;'
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    git
    makeWrapper
  ];

  buildInputs = [
    aws-lc
    openssl
    alsa-lib
    libopus
    sqlite
    rust-jemalloc-sys
  ]
  ++ gpuiLibs;

  env = {
    RUSTY_V8_ARCHIVE = librustyV8;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    KOPUZ_PLUGIN_WASM_DIR = finalAttrs.passthru.plugins;
  };

  cargoBuildFlags = [
    "-p"
    "kopuz"
    "-p"
    "kopuz-kopuzd"
    "-p"
    "kopuz-ctl"
  ];

  cargoTestFlags = finalAttrs.cargoBuildFlags;

  postInstall = ''
    install -Dm644 packaging/systemd/kopuzd.service $out/share/systemd/user/kopuzd.service
    substituteInPlace $out/share/systemd/user/kopuzd.service \
      --replace-fail "ExecStart=kopuzd" "ExecStart=$out/bin/kopuzd"

    install -Dm644 data/moe.kopuz.kopuz.desktop $out/share/applications/moe.kopuz.kopuz.desktop
    substituteInPlace $out/share/applications/moe.kopuz.kopuz.desktop \
      --replace-fail "Exec=kopuz" "Exec=$out/bin/kopuz"
    install -Dm644 data/moe.kopuz.kopuz.metainfo.xml $out/share/metainfo/moe.kopuz.kopuz.metainfo.xml
    install -Dm644 apps/legacy/kopuz/assets/logo.png \
      $out/share/icons/hicolor/256x256/apps/moe.kopuz.kopuz.png

    wrapProgram $out/bin/kopuz --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath gpuiLibs}
    wrapProgram $out/bin/kopuzd \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libcdio
          libcdio-paranoia
        ]
      }
  '';

  passthru.plugins = callPackage ./plugins.nix { kopuz = finalAttrs.finalPackage; };

  meta = {
    description = "Fast, modern music player with Jellyfin and local library support";
    homepage = "https://github.com/Kopuz-org/kopuz";
    changelog = "https://github.com/Kopuz-org/kopuz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [
      temidaradev
      NotAShelf
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "kopuz";
  };
})
