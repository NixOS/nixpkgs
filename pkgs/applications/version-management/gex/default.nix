{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
}:

rustPlatform.buildRustPackage rec {
  pname = "gex";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Piturnah";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eRforLvRVSrFWnI5UZEWr1L4UM3ABjAIvui1E1hzk5s=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgit2 ];

  cargoHash = "sha256-OEaNERozmJL8gYe33V/m4HQNHi2I4KHpI6PTwFQkPSs=";

  meta = with lib; {
    description = "Git Explorer: cross-platform git workflow improvement tool inspired by Magit";
    homepage = "https://github.com/Piturnah/gex";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ azd325 Br1ght0ne ];
  };
}
