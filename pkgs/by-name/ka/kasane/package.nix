{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  kakoune,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
  withGui ? true,
  vulkan-loader,
  wayland,
  libxkbcommon,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  fontconfig,
  freetype,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kasane";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Yus314";
    repo = "kasane";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KPD3d2AZ/1uvT7xcRsx5U4wLsL5xPAfgiuJH1BG8Bl8=";
  };

  cargoHash = "sha256-3dSauBVS6DLo718VW6YoRRgAsfbwyGub6MVDUWD9rzs=";

  cargoBuildFlags = [
    "-p"
    "kasane"
  ];
  buildFeatures = lib.optional withGui "gui";

  # gui feature only exists in the kasane crate, not in test targets
  checkFeatures = [ ];

  # kasane crate tests require a running kakoune process
  cargoTestFlags = [
    "-p"
    "kasane-core"
    "-p"
    "kasane-tui"
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = lib.optionals (withGui && stdenv.hostPlatform.isLinux) [
    fontconfig
    freetype
    libx11
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    vulkan-loader
    wayland
  ];

  postInstall = ''
    wrapProgram $out/bin/kasane \
      --prefix PATH : ${lib.makeBinPath [ kakoune ]}
  '';

  # Vulkan, Wayland, and libxkbcommon are loaded via dlopen at runtime.
  # Add their paths after shrink-rpath so they are preserved.
  postFixup = lib.optionalString (withGui && stdenv.hostPlatform.isLinux) ''
    patchelf --add-rpath ${
      lib.makeLibraryPath [
        vulkan-loader
        wayland
        libxkbcommon
      ]
    } $out/bin/.kasane-wrapped
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Alternative frontend for the Kakoune text editor";
    homepage = "https://github.com/Yus314/kasane";
    license = with lib.licenses; [
      mit # OR
      asl20
    ];
    changelog = "https://github.com/Yus314/kasane/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ yus314 ];
    mainProgram = "kasane";
  };
})
