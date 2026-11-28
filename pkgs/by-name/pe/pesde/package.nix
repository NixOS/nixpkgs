{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  dbus,
  libgit2,
  versionCheckHook,
}:

rustPlatform.buildRustPackage {
  pname = "pesde";
  version = "0.7.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pesde-pkg";
    repo = "pesde";
    rev = "889d673a76b310abd2cc2e3eaf8a1571caabeb8e";
    hash = "sha256-qwCdoAP6axC+ZH4WXX+4xy0+9oHFY4Irbj9xzcnh2iw=";
  };

  cargoHash = "sha256-ELIXmphp+7lvWQsuUz2iyxhjQs0N3gzepQ4H8g13xg0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    dbus
    libgit2
  ];
  buildFeatures = [ "bin" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Package manager for the Luau programming language, supporting multiple runtimes including Roblox and Lune";
    homepage = "https://github.com/pesde-pkg/pesde";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      daimond113
      vokinn
    ];
    mainProgram = "pesde";
  };
}
