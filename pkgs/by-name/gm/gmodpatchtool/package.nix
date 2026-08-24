{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "gmodpatchtool";
  version = "20260722";

  src = fetchFromGitHub {
    owner = "solsticegamestudios";
    repo = "GModPatchTool";
    tag = "${version}";
    sha256 = "sha256-eIdgJSkZJ51PwRnf2cD+us9z/GRFSEk1ozT8GlalsHA=";
    fetchLFS = true;
  };

  cargoHash = "sha256-2+FS5gFDeXe1yPMtCFJnaTkp+ImzbJG6SrL5y3U3ZFI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Patches for Garry's Mod";
    homepage = "https://github.com/solsticegamestudios/GModPatchTool";
    license = with lib.licenses; [ gpl3 ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ karalynx ];
  };
}