{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adguardian";
  version = "1.8.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Lissy93";
    repo = "AdGuardian-Term";
    tag = finalAttrs.version;
    hash = "sha256-S4HtlRq1tB0cAPiAGuXMOdzjzXG0u0pnPHzghps5E5A=";
  };

  cargoHash = "sha256-uch2JKnskO5W8EPK877qL0aQQ+iInHJoCrrhZbmoVRs=";

  meta = {
    description = "Terminal-based, real-time traffic monitoring and statistics for your AdGuard Home instance";
    mainProgram = "adguardian";
    homepage = "https://github.com/Lissy93/AdGuardian-Term";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
