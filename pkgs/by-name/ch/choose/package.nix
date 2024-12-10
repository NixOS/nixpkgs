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
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ojmib9yri/Yj1VSwwssbXv+ThnZjUXLTmOpfPGdGFaU=";
  };

  cargoHash = "sha256-PnY1yk9SvAvpsQ/QzTQuuBmvbEfd3yKcNcTU8LZVhsE=";

  meta = with lib; {
    description = "Human-friendly and fast alternative to cut and (sometimes) awk";
    mainProgram = "choose";
    homepage = "https://github.com/theryangeary/choose";
    license = licenses.gpl3;
    maintainers = with maintainers; [ sohalt ];
  };
}
