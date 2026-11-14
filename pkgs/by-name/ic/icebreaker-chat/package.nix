{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cmake,
  nix-update-script,
  libxkbcommon,
  vulkan-loader,
  wayland,
  libxi,
  libxcursor,
  libx11,
  libxcb,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "icebreaker-chat";
  version = "2026.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hecrj";
    repo = "icebreaker";
    tag = finalAttrs.version;
    hash = "sha256-2CW8GhYEJgW/2PNCS3fp1OlwtN6+wL2gCV9404gBaUk=";
  };

  cargoHash = "sha256-2VcZvL0HPdbkOxKTY4rnDl42hXFmvXG8Ua6cEa/MBCE=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libxkbcommon
    vulkan-loader
    wayland
    libx11
    libxcursor
    libxi
    libxcb
  ];

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux (
    let
      rpath = lib.makeLibraryPath [
        wayland
        vulkan-loader
        libxkbcommon
      ];
    in
    ''
      patchelf --set-rpath "$(patchelf --print-rpath $out/bin/icebreaker):${rpath}" $out/bin/icebreaker
    ''
  );

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local AI chat app powered by Rust, iced, Hugging Face, and llama.cpp";
    homepage = "https://github.com/hecrj/icebreaker";
    changelog = "https://github.com/hecrj/icebreaker/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DerGrumpf ];
    mainProgram = "icebreaker";
    platforms = lib.platforms.unix;
  };
})
