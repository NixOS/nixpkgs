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
  version = "3.8.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "encounter";
    repo = "objdiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zLf2vElF39HrCWbq++3ytU9vIO+G5d/vUwJj1Z8asGk=";
  };

  cargoHash = "sha256-5LE5g8KgOxIBt6lTnn2m8wvfNj2T4Ap06jLVeSo2feQ=";

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
