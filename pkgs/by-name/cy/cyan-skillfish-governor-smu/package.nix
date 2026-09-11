{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libdrm,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cyan-skillfish-governor-smu";
  version = "0.4.12";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "filippor";
    repo = "cyan-skillfish-governor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yer2MlLnj9lx2cEBeYqAktbx0BqQEK/eFPiga5gXCr8=";
  };

  cargoHash = "sha256-zlAVGLGnub2Gc0Bkzb5GU9NBAJ2YWLhIG8JOa+1wHx8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libdrm ];

  env.CYAN_SKILLFISH_GOVERNOR_VERSION = finalAttrs.version;

  postInstall = ''
    install -Dm755 scripts/cyan-skillfish-performance-mode \
      $out/bin/cyan-skillfish-performance-mode

    install -Dm644 com.cyanskillfish.Governor.conf \
      $out/share/dbus-1/system.d/com.cyanskillfish.Governor.conf

    install -Dm644 default-config.toml \
      $out/share/cyan-skillfish-governor-smu/default-config.toml
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "SMU-based GPU governor for the AMD Cyan Skillfish APU (ASRock BC-250)";
    homepage = "https://github.com/filippor/cyan-skillfish-governor";
    changelog = "https://github.com/filippor/cyan-skillfish-governor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ liberodark ];
    mainProgram = "cyan-skillfish-governor-smu";
  };
})
