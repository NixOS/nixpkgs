{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  pkg-config,
  libgit2,
  nix-update-script,
  zlib,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gex";
  version = "0.6.8";

  src = fetchFromCodeberg {
    owner = "Piturnah";
    repo = "gex";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UMLWZuAQq0mJKbHzxwpcZA3xhg7MVwPGeVXnwwqX8pM=";
  };

  nativeBuildInputs = [ pkg-config ];

  passthru.updateScript = nix-update-script { };

  buildInputs = [
    libgit2
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ zlib ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  cargoHash = "sha256-GiZfSshLDsKW7ZhMuADCW+CV862asrzxpgUXtWX/pV4=";

  meta = {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://codeberg.org/Piturnah/gex";
    changelog = "https://codeberg.org/Piturnah/gex/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      azd325
      bot-wxt1221
      evanrichter
      piturnah
    ];
    mainProgram = "gex";
  };
})
