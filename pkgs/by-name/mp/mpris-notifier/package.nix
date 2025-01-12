{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpris-notifier";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "l1na-forever";
    repo = "mpris-notifier";
    rev = "v${version}";
    hash = "sha256-X9d410ijZZcHvf8+f6DgnMl8ETGeY/fN13Gpz6q3BBA=";
  };

  cargoHash = "sha256-f8BCnjgv7OLWQ/2X3dTUuAarCl+u+4CRARSQsO+09zE=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Dependency-light, highly-customizable, XDG desktop notification generator for MPRIS status changes";
    homepage = "https://github.com/l1na-forever/mpris-notifier";
    license = licenses.mit;
    maintainers = with maintainers; [ leixb ];
    mainProgram = "mpris-notifier";
  };
}
