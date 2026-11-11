{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rdx";
  version = "0.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Ch0pin";
    repo = "rdx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ycLHnqiZ/P1xKC1W0a0aXuy/2bsbM2tBv2pZKDs3RqI=";
  };

  cargoHash = "sha256-Q32ihQVkgC5tMwf7bXQevi2UQhoUC/encrtlcuJnxiQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libxkbcommon
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wayland
  ];

  cargoTestFlags = [
    "--lib"
    "--bins"
  ];

  checkFlags = [
    "--skip=native_java::cast_cleanup::tests::jvm_original_and_cleaned_preserve_values_and_overload_choice"
    "--skip=transport::tests::noisy_stderr_is_drained_and_bounded"
    "--skip=transport::tests::timeout_includes_blocked_stdin_and_closes_transport"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "APK and DEX decompiler";
    homepage = "https://github.com/Ch0pin/rdx";
    changelog = "https://github.com/Ch0pin/rdx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "rdx";
  };
})
