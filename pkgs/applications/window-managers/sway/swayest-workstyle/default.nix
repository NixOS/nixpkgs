{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "swayest-workstyle";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Lyr-7D1h";
    repo = "swayest_workstyle";
    rev = version;
    sha256 = "sha256-LciTrYbmJV0y0H6QH88vTBXbDdDSx6FQtO4J/CFLjtY=";
  };

  cargoSha256 = "sha256-34Ij3Hd1JI6d1vhv1XomFc9SFoB/6pbS39upLk+NeQM=";

  doCheck = false; # No tests

  meta = with lib; {
    description = "Map sway workspace names to icons defined depending on the windows inside of the workspace";
    homepage = "https://github.com/Lyr-7D1h/swayest_workstyle";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ miangraham ];
    mainProgram = "sworkstyle";
  };
}
