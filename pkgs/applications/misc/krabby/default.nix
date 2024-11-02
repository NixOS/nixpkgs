{ lib
, rustPlatform
, fetchCrate
}:
rustPlatform.buildRustPackage rec {
  pname = "krabby";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-R4GW0e0tjLiCXQMf8iA+yYyMp43/28GeNsjs+QNQMSM=";
  };

  cargoHash = "sha256-eQyU0sMfecOjX5k1qYeetrAhk41FIMcg9QmhhTYOxWc=";

  meta = with lib; {
    description = "Print pokemon sprites in your terminal";
    homepage = "https://github.com/yannjor/krabby";
    changelog = "https://github.com/yannjor/krabby/releases/tag/v${version}";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ruby0b ];
    mainProgram = "krabby";
  };
}
