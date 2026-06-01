{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adguardian";
  version = "1.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Lissy93";
    repo = "AdGuardian-Term";
    tag = finalAttrs.version;
    hash = "sha256-GXGABTBX4Cot558ML0quD8GDU3RWj0BoZ8Ib/SbuWmg=";
  };

  cargoHash = "sha256-JJDMrRJVs67EMcGTK75tdU+FhdkiF3RswrZ0fOWrG/U=";

  meta = {
    description = "Terminal-based, real-time traffic monitoring and statistics for your AdGuard Home instance";
    mainProgram = "adguardian";
    homepage = "https://github.com/Lissy93/AdGuardian-Term";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
