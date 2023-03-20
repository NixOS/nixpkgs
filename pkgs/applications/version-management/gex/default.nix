{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oUcQKpZqqb8wZDpdFfpxLpwdfQlokJE5bsoPwxh+JMM=";
  };

  cargoHash = "sha256-ZFrIlNysjlXI8n78N2Hkff6gAplipxSQXUWG8HJq8fs=";

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
