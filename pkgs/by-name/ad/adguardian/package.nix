{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "adguardian";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Lissy93";
    repo = "AdGuardian-Term";
    tag = version;
    hash = "sha256-WxrSmCwLnXXs5g/hN3xWE66P5n0RD/L9MJpf5N2iNtY=";
  };

  cargoHash = "sha256-yPDysaslL/7N60eZ/hqZl5ZXIsof/pvlgHYfW1mIWtI=";

<<<<<<< HEAD
  meta = {
    description = "Terminal-based, real-time traffic monitoring and statistics for your AdGuard Home instance";
    mainProgram = "adguardian";
    homepage = "https://github.com/Lissy93/AdGuardian-Term";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
=======
  meta = with lib; {
    description = "Terminal-based, real-time traffic monitoring and statistics for your AdGuard Home instance";
    mainProgram = "adguardian";
    homepage = "https://github.com/Lissy93/AdGuardian-Term";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
