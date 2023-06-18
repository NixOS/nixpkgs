{ lib
, stdenv
, git
, openssl
, pkg-config
, rustPlatform
, fetchFromGitHub
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

  cargoHash = "sha256-+FwXm3QN9bt//dWqzkBzsGigyl1SSY4/P29QtV75V6M=";

  nativeBuildInputs = [ pkg-config git ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
