{
  lib,
  rustPlatform,
  pkg-config,
  libgit2,
  libxkbcommon,
  openssl,
  vulkan-loader,
  zlib,
  stdenv,
  wayland,
  nix-update-script,
  fetchFromCodeberg,
  dbus,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cheese-paper";
  version = "1.0.0-unstable-2026-08-16";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ByteOfBrie";
    repo = "cheese-paper";
    rev = "17ee1ee33077321bb0b04c2c9ede55f5a2acdb4d";
    hash = "sha256-UiOpavy0N486NQ8yINKYRKWalZnPtBWPZgwFZThG2CY=";
    fetchLFS = true;
  };
  cargoHash = "sha256-LZCX40dq+NlD6EEaKD1JtKloUqudjO9IssAXOpmSWD8=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libgit2
    libxkbcommon
    openssl
    vulkan-loader
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ];

  # disable update checking
  buildNoDefaultFeatures = true;

  postFixup = ''
    wrapProgram $out/bin/cheese-paper \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          wayland
          vulkan-loader
          libxkbcommon
          dbus
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Organized writing tool with simple file format";
    homepage = "https://codeberg.org/ByteOfBrie/cheese-paper";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aquifolly ];
    mainProgram = "cheese-paper";
  };
})
