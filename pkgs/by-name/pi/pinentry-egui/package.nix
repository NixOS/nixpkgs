{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  expat,
  fontconfig,
  freetype,
  libGL,
  libxkbcommon,
  wayland,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pinentry-egui";
  version = "0.2.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dsociative";
    repo = "pinentry-egui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rQqJRhsZXQc7DlpzjAF+r/979bjx1vksPzpjHOYfbjU=";
  };

  cargoHash = "sha256-UufCu0MIYEN0ezn7y4OSuutiYwkbiCfx0xAHWnMEm3A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    expat
    fontconfig
    freetype
    libGL
    libxkbcommon
    wayland
    libx11
    libxcursor
    libxi
    libxrandr
  ];

  postInstall = ''
    # This is a requirement for gpg-agent and yubikey-agent.
    ln -s $out/bin/pinentry-egui $out/bin/pinentry
  '';

  postFixup = ''
    patchelf $out/bin/pinentry-egui \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern, native Wayland pinentry implementation for GPG using egui";
    homepage = "https://github.com/dsociative/pinentry-egui";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = with lib.maintainers; [ colemickens ];
    mainProgram = "pinentry-egui";
    platforms = lib.platforms.linux;
  };
})
