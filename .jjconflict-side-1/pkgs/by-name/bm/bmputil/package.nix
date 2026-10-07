{
  blackmagic,
  lib,
  stdenv,
  fetchFromCodeberg,
  rustPlatform,
  versionCheckHook,
  udevCheckHook,
  pkg-config,
  udev,
}:
rustPlatform.buildRustPackage rec {
  pname = "bmputil";
  version = "1.2.0";

  src = fetchFromCodeberg {
    owner = "blackmagic-debug";
    repo = "bmputil";
    tag = "v${version}";
    hash = "sha256-WX26rDFLWtEG/BvVwPjsY3X1ebvNseEpdgJRGMynyBo=";
  };

  cargoHash = "sha256-Uj+TLD1SGx5lFFhSDKRr6iMg4QnjgE1+1KbXTi/5iCI=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    udev
  ];

  postInstall = ''
    install -Dm 444 ${blackmagic.src}/driver/99-blackmagic-plugdev.rules $out/lib/udev/rules.d/99-blackmagic-plugdev.rules
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
    udevCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Black Magic Probe companion utility";
    homepage = "https://codeberg.org/blackmagic-debug/bmputil";
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
