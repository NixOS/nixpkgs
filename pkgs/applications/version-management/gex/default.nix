{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
# waiting on gex to update to libgit2-sys >= 0.15
, libgit2_1_5
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pjyS0H25wdcexpzZ2vVzGTwDPzyvA9PDgzz81yLGTOY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libgit2_1_5 ];

  cargoHash = "sha256-+FwXm3QN9bt//dWqzkBzsGigyl1SSY4/P29QtV75V6M=";

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ azd325 Br1ght0ne ];
  };
}
