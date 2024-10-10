{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "grafana-to-ntfy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kittyandrew";
    repo = pname;
    rev = "325337f4dc2fe44427262f063f2a594cc226f55f";
    sha256 = "sha256-zEm06aq44IcUXIrm9Upovmifu4INpLjE3dMXahHppwk=";
  };

  cargoHash = "sha256-IdONQaAgUBeuz5GNnJ0fSFG6X686QJsT7AiGUrLztt0=";

  nativeBuildInputs = lib.optionals (stdenv.isLinux) [ pkgs.pkg-config ];

  buildInputs =
    lib.optionals (stdenv.isLinux) [ pkgs.openssl ]
    ++ lib.optionals (stdenv.isDarwin) [ pkgs.darwin.apple_sdk.frameworks.Security ];

  meta = {
    description = "Bridge to bring Grafana Webhook alerts to ntfy.sh";
    homepage = "https://github.com/kittyandrew/grafana-to-ntfy";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jeyemwey ];
  };
}
