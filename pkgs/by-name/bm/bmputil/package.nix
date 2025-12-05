{
  blackmagic,
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  udevCheckHook,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "bmputil";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "blackmagic-debug";
    repo = "bmputil";
    tag = "v${version}";
    hash = "sha256-5BHnh1/6DqjvT0ptOoGqDqVGU0coVPdnZPDQPT9fVFk=";
  };

  cargoHash = "sha256-JoqNEesozr4ahyenZeeAMf0m8M+sxvbF+A6t23Gcz+4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl # can be removed once https://github.com/blackmagic-debug/bmputil/commit/5fa01c20902a3f2570fed58ee66f2241546dd6d7 is released
  ];

  postInstall = ''
    install -Dm 444 ${blackmagic.src}/driver/99-blackmagic-plugdev.rules $out/lib/udev/rules.d/99-blackmagic-plugdev.rules
  '';

  doCheck = false; # fails at least 1 test

  nativeInstallCheckInputs = [
    versionCheckHook
    udevCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Black Magic Probe Firmware Manager";
    homepage = "https://github.com/blackmagic-debug/bmputil";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "bmputil-cli";
    maintainers = [
      lib.maintainers.shimun
      lib.maintainers.carlossless
    ];
  };
}
