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
  version = "1.0.0-unstable-2026-07-05";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ByteOfBrie";
    repo = "cheese-paper";
    rev = "c4554acd410604f56419fef66c1144859891c128";
    hash = "sha256-rooocVpNqA3kvGgfwK9PVZupUiZLU0QyRIoN2zlc0zM=";
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
  ++ lib.optionals stdenv.isLinux [
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
