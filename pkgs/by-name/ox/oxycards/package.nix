{ lib
, rustPlatform
, fetchFromGitHub
, unstableGitUpdater
}:

rustPlatform.buildRustPackage {
  pname = "oxycards";
  version = "unstable-2023-03-11";

  src = fetchFromGitHub {
    owner = "BrookJeynes";
    repo = "oxycards";
    rev = "aef415f17ee30b6af897121091912e190b70537d";
    hash = "sha256-YNqNNW7sozuWppuRoM8dfx+HaIuLvqriq7V0KJJJkGI=";
  };

  cargoHash = "sha256-0mA5OAWL8pNP3riu2lBmmvMtYIBJH6eNX3Ibp5ikNj4=";

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Oxycards is a quiz card application built within the terminal";
    homepage = "https://github.com/BrookJeynes/oxycards";
    license = licenses.mit;
    maintainers = with maintainers; [ unidealisticraccoon ];
    mainProgram = "oxycards";
  };
}
