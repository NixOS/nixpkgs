{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rtrtr";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "rtrtr";
    rev = "v${finalAttrs.version}";
    hash = "sha256-n6dpORKh9ul9VQXKXtnkuewUnQOmge99HljUgVpO2HM=";
  };

  cargoHash = "sha256-3Atv3lEQIiM5MNjdQdLUnUDb3rHICxDAhQq0yuLSgtA=";
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
    changelog = "https://github.com/NLnetLabs/rtrtr/blob/v${finalAttrs.version}/Changelog.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ steamwalker ];
    mainProgram = "rtrtr";
  };
})
