{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "reap";
  version = "0.3-unreleased";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "reap";
    rev = "0e68d09804fb9ec82af37045fb37c2ceefa391d5";
    hash = "sha256-4Bv7stW5PKcODQanup37YbiUWrEGR6BuSFXibAHmwn0=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    install -dm755 "$out/share/licenses/reap/"
  '';

  meta = with lib; {
    homepage = "https://github.com/leahneukirchen/reap";
    description = "run process until all its spawned processes are dead";
    mainProgram = "reap";
    license = with licenses; [ publicDomain ];
    platforms = platforms.linux;
    maintainers = [ maintainers.leahneukirchen ];
  };
}
