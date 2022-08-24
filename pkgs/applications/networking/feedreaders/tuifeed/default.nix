{ lib
, stdenv
, fetchCrate
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tuifeed";
  version = "0.2.1";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-QMjMJVr+OI/5QQTwNVpUQdnYSWpWmZMuEcg5UgPpcAk=";
  };

  cargoHash = "sha256-NPrROFV2Yx4p4CocVMY2dPAlgcdZrZQfa779beLAbcI=";

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  doCheck = false;

  meta = with lib; {
    description = "A terminal feed reader with a fancy UI";
    homepage = "https://github.com/veeso/tuifeed";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ devhell ];
  };
}
