{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  darwin,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "grafana-to-ntfy";
  version = "0-unstable-2024-10-04";

  src = fetchFromGitHub {
    owner = "kittyandrew";
    repo = "grafana-to-ntfy";
    rev = "325337f4dc2fe44427262f063f2a594cc226f55f";
    sha256 = "sha256-zEm06aq44IcUXIrm9Upovmifu4INpLjE3dMXahHppwk=";
  };

  cargoHash = "sha256-IdONQaAgUBeuz5GNnJ0fSFG6X686QJsT7AiGUrLztt0=";

  nativeBuildInputs = lib.optionals (stdenv.hostPlatform.isLinux) [ pkg-config ];

  buildInputs =
    lib.optionals (stdenv.hostPlatform.isLinux) [ openssl ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [ darwin.apple_sdk.frameworks.Security ];

  meta = {
    description = "Bridge to bring Grafana Webhook alerts to ntfy.sh";
    homepage = "https://github.com/kittyandrew/grafana-to-ntfy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jeyemwey ];
    mainProgram = "grafana-to-ntfy";
  };
}
