{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "rtrtr";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "rtrtr";
    rev = "v${version}";
    hash = "sha256-1TmzC/d/odfYdo1CiCsFW3U7OCpTF4Gkw2w4c2yaxxw=";
  };

  cargoHash = "sha256-SeQ2zRBbETabAhOItu3C6PUjL7vUsVDzWGbYcUIslF4=";
  nativeBuildInputs = [ pkg-config ];

  buildNoDefaultFeatures = true;

  meta = {
    description = "RPKI data proxy";
    longDescription = ''
      TRTR is an RPKI data proxy, designed to collect Validated ROA Payloads
      from one or more sources in multiple formats and dispatch it onwards. It
      provides the means to implement multiple distribution architectures for RPKI
      such as centralised RPKI validators that dispatch data to local caching RTR
      servers. RTRTR can read RPKI data from multiple RPKI Relying Party packages via
      RTR and JSON and, in turn, provide an RTR service for routers to connect to.
    '';
    homepage = "https://github.com/NLnetLabs/rtrtr";
    changelog = "https://github.com/NLnetLabs/rtrtr/blob/v${version}/Changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ steamwalker ];
    mainProgram = "rtrtr";
  };
}
