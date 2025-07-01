{
  blackmagic,
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  udevCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "bmputil";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "blackmagic-debug";
    repo = "bmputil";
    tag = "v${version}";
    hash = "sha256-LKtdwQbsPNEu3EDTowOXeFmi5OHOU3kq5f5xxevBjtM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-32dTB5gOMgy6Fn62p68tAZB8AYwh1BAW+kwwuZPGJyM=";

  postInstall = ''
    install -Dm 444 ${blackmagic.src}/driver/99-blackmagic.rules $out/lib/udev/rules.d/99-blackmagic.rules
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  nativeBuildInputs = [ udevCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Black Magic Probe Firmware Manager";
    homepage = "https://github.com/blackmagic-debug/bmputil";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "bmputil";
    maintainers = [ lib.maintainers.shimun ];
  };
}
