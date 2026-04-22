{
  blackmagic,
  lib,
  fetchFromCodeberg,
  rustPlatform,
  versionCheckHook,
  udevCheckHook,
  pkg-config,
  openssl,
  udev,
}:
rustPlatform.buildRustPackage rec {
  pname = "bmputil";
  version = "1.1.0";

  src = fetchFromCodeberg {
    owner = "blackmagic-debug";
    repo = "bmputil";
    tag = "v${version}";
    hash = "sha256-ZD/JXsx52U+O3FazRc9xnShx34fxTXcD2zhW5mgSYtU=";
  };

  cargoHash = "sha256-/I1chzqnhgky/+cKGhFrdgZvoLGM9P75ga5UDTMOI3Q=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    udev
  ];

  postInstall = ''
    install -Dm 444 ${blackmagic.src}/driver/99-blackmagic-plugdev.rules $out/lib/udev/rules.d/99-blackmagic-plugdev.rules
  '';

  doCheck = false; # fails at least 1 test

  nativeInstallCheckInputs = [
    versionCheckHook
    udevCheckHook
  ];
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
