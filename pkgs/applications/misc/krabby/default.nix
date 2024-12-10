{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "krabby";
  version = "0.1.8";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-pqLk05hDPMvbrDG3xatAP0licaJszBSujo1fqsEtpRI=";
  };

  cargoHash = "sha256-/wXfdH9ObKGOw8EXHG/3Gvhm66v632lpDp/V3zFIzh4=";

  meta = with lib; {
    description = "Print pokemon sprites in your terminal";
    homepage = "https://github.com/yannjor/krabby";
    changelog = "https://github.com/yannjor/krabby/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ruby0b ];
    mainProgram = "krabby";
  };
}
