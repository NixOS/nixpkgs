{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gilt-rs";
  version = "0.3.7";

  src = fetchFromGitHub {
    owner = "simonhollingshead";
    repo = "gilt-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kGmHf+knEurVTz7K7MtDkDFWIDs8nIp4CrsBHwnjg6s=";
  };

  cargoHash = "sha256-4YlfR2ft5D910IKSDx/3PxrwFLln2dqscdVg+OhnSYk=";

  __structuredAttrs = true;

  meta = {
    description = "Tool for calculating which UK Gilt will give the best return if held to maturity";
    homepage = "https://github.com/simonhollingshead/gilt-rs";
    license = lib.licenses.mit;
    mainProgram = "gilt";
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
