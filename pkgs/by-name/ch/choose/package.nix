{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "choose";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "theryangeary";
    repo = "choose";
    rev = "v${version}";
    sha256 = "sha256-ojmib9yri/Yj1VSwwssbXv+ThnZjUXLTmOpfPGdGFaU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SecWDujJu68K1LMQJQ55LeW51Ag/aCt1YKcdWeRp22c=";

  meta = with lib; {
    description = "Human-friendly and fast alternative to cut and (sometimes) awk";
    mainProgram = "choose";
    homepage = "https://github.com/theryangeary/choose";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sohalt ];
  };
}
