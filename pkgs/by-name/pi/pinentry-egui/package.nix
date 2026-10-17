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
  version = "0-unstable-2026-07-10";

  src = fetchFromGitHub {
    owner = "dsociative";
    repo = "pinentry-egui";
    rev = "c81bf237048f5b296488751467bb2975982d05af";
    hash = "sha256-xUhPaXiysXbOctM3FO6WgafVPUOQ+9lP2d4U9PBxCvk=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-81W3NOQ6EOV3bMt7SYtg3AjAgmdHZ81gEtQkaOYVFIk=";
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
