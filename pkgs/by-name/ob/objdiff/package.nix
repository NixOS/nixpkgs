{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  fontconfig,
  freetype,
  libxkbcommon,
  openssl,
  vulkan-loader,
  stdenv,
  wayland,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "objdiff";
  version = "3.8.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "encounter";
    repo = "objdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KF37Y9D/vmGq1Y7017IjeoFZk/G7aK98vYYYQe5QxaU=";
  };

  cargoHash = "sha256-HERAeWyA8pDpMCGVAssY2r66i7AfbqmlvJ/4zbDDe2M=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    fontconfig
    freetype
    libxkbcommon
    openssl
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local diffing tool for decompilation projects";
    homepage = "https://github.com/encounter/objdiff";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "objdiff";
  };
})
