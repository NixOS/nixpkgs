{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  dbus,
}:

rustPlatform.buildRustPackage {
  pname = "pesde";
  version = "0.7.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pesde-pkg";
    repo = "pesde";
    rev = "611c484ed26aa6a7151d5f2c85e5048012eefdac";
    hash = "sha256-4SF+k14QQGrkrJ0qYGY1khjQmm9gA6aLQjv5bAIe9gY=";
  };

  cargoHash = "sha256-/jQmlkgWY6tqenwi/ceavGkz8BPwvx+DCzBjKA0w5ZU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    dbus
  ];
  buildFeatures = [ "bin" ];

  meta = {
    description = "Package manager for the Luau programming language, supporting multiple runtimes including Roblox and Lune.";
    homepage = "https://github.com/pesde-pkg/pesde";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      daimond113
      vokinn
    ];
    mainProgram = "pesde";
  };
}
