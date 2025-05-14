{
  dbus,
  openssl,
  freetype,
  libsoup_2_4,
  gtk3,
  webkitgtk_4_0,
  pkg-config,
  wrapGAppsHook3,
  parallel-disk-usage,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  rustPlatform,
  cargo-tauri_1,
  lib,
  stdenv,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-dFTdbMX355klZ2wY160bYcgMiOiOGplEU7/e6Btv5JI=";

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

  postPatch = ''
    # Use pdu binary from nixpkgs instead of the vendored prebuilt binary
    rm src-tauri/bin/pdu-*
    cp ${parallel-disk-usage}/bin/pdu src-tauri/bin/pdu-${stdenv.hostPlatform.rust.rustcTarget}
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    npmHooks.npmConfigHook
    nodejs
    cargo-tauri_1.hook
  ];

  buildInputs = [
    dbus
    openssl
    freetype
    libsoup_2_4
    gtk3
    webkitgtk_4_0
  ];

  # Disable checkPhase, since the project doesn't contain tests
  doCheck = false;

  # We'll wrap the main binary manually
  dontWrapGApps = true;

  # WEBKIT_DISABLE_COMPOSITING_MODE essential in NVIDIA + compositor https://github.com/NixOS/nixpkgs/issues/212064#issuecomment-1400202079
  postFixup = ''
    wrapGApp "$out/bin/squirrel-disk" \
      --set WEBKIT_DISABLE_COMPOSITING_MODE 1
  '';

  meta = with lib; {
    description = "Cross-platform disk usage analysis tool";
    homepage = "https://www.squirreldisk.com/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ peret ];
    mainProgram = "squirrel-disk";
  };
}
