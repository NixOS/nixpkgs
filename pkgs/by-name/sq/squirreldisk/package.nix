{
  lib,
  stdenv,
  rustPlatform,

  fetchFromGitHub,
  fetchNpmDeps,

  cargo-tauri_1,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  pkg-config,
  wrapGAppsHook3,

  dbus,
  freetype,
  gtk3,
  libsoup_2_4,
  openssl,
  parallel-disk-usage,
  webkitgtk_4_0,
}:

rustPlatform.buildRustPackage rec {
  pname = "squirreldisk";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "adileo";
    repo = "squirreldisk";
    rev = "v${version}";
    hash = "sha256-As2nvc68knjeLPuX0QLBoybj8vuvkpS5Vr+7U7E5CjA=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  cargoHash = "sha256-PfpbzawgwkqykG4u2G05rgZwksuxWJUcv6asnJvZJvU=";

  npmDeps = fetchNpmDeps {
    name = "squirreldisk-${version}-npm-deps";
    inherit src;
    hash = "sha256-Japcn0KYP7aYIDK8+Ns+mrnbbAb0fLWXHIV2+yltI6I=";
  };

  patches = [
    # Update field names to work with pdu versions >=0.10.0
    # https://github.com/adileo/squirreldisk/pull/47
    ./update-pdu-json-format.patch
  ];

  cargoPatches = [
    # Remove dependency on parallel-disk-usage crate. The version is outdated and
    # does not compile anymore with Rust 1.87.0.
    # https://github.com/adileo/squirreldisk/pull/49
    ./remove-pdu-crate.patch
  ];

  postPatch = ''
    # Use pdu binary from nixpkgs instead of the vendored prebuilt binary
    rm src-tauri/bin/pdu-*
    cp ${parallel-disk-usage}/bin/pdu src-tauri/bin/pdu-${stdenv.hostPlatform.rust.rustcTarget}
  '';

  nativeBuildInputs = [
    cargo-tauri_1.hook
    npmHooks.npmConfigHook
    nodejs
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    freetype
    gtk3
    libsoup_2_4
    openssl
    webkitgtk_4_0
  ];

  # Disable checkPhase, since the project doesn't contain tests
  doCheck = false;

  # We'll wrap the main binary manually
  dontWrapGApps = true;

  # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapGApp "$out/bin/squirrel-disk" \
        --set WEBKIT_DISABLE_COMPOSITING_MODE 1
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeWrapper "$out/Applications/SquirrelDisk.app/Contents/MacOS/SquirrelDisk" "$out/bin/squirrel-disk"
    '';

  meta = with lib; {
    description = "Cross-platform disk usage analysis tool";
    homepage = "https://www.squirreldisk.com/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ peret ];
    mainProgram = "squirrel-disk";
  };
}
