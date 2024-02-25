{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "river-filtile";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "pkulak";
    repo = "filtile";
    rev = "v${version}";
    hash = "sha256-51lrmti5/fTJpl0eF4BRvosT76wWfWdYI1yJJahi0Aw=";
  };

  cargoHash = "sha256-KWapy2p9kVzgx5oqCo0+7DNaVlDaHYHNi8Mra2I13DQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "A layout manager for the River window manager";
    homepage = "https://github.com/pkulak/filtile";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ pkulak ];
    mainProgram = "filtile";
  };
}
