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
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "ByteOfBrie";
    repo = "cheese-paper";
    tag = finalAttrs.version;
    hash = "sha256-f+9/IGFU4Qb8g2wXlyYTSjQZritvWhR62C8iYyxhTV8=";
    fetchLFS = true;
  };
  cargoHash = "sha256-p0JbBsP8EIEGMIijJWfNy9mkpqt2MdVG3va1gWD8cQc=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
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

  env = {
    LIBGIT2_NO_VENDOR = true;
    OPENSSL_NO_VENDOR = true;
  };

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
