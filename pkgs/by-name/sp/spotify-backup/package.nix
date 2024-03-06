{ lib
, fetchFromGitHub
, stdenv
, python3
}:

stdenv.mkDerivation {
  pname = "spotify-backup";
  version = "0-unstable-2023-02-24";

  src = fetchFromGitHub {
    owner = "caseychu";
    repo = "spotify-backup";
    rev = "0ccf12c9c7a399c6a08a38366ee02151ea04369b";
    hash = "sha256-+z9IWgtc71GPPLDqNU4PXFDyD5Dczp3Bbrwzy/DaIts=";
  };

  propagatedBuildInputs = [
    python3
  ];

  installPhase = ''
    install -Dm755 spotify-backup.py $out/bin/spotify-backup
  '';

  meta = with lib; {
    description = "A Python script that exports all of your Spotify playlists";
    homepage = "https://github.com/caseychu/spotify-backup";
    license = licenses.mit;
    mainProgram = "spotify-backup";
  };
}

