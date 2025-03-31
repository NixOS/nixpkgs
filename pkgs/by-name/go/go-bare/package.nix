{
  buildGoModule,
  fetchFromSourcehut,
  lib,
}:

buildGoModule {
  pname = "go-bare";
  version = "0-unstable-2021-04-06";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "go-bare";
    rev = "ab86bc2846d997bc8760fdb0d06d4a55e746b1db";
    hash = "sha256-SKTYDKidB1Ia3Jg4EBg5rPAtqlXAa19RY5qieS82A34=";
  };

  vendorHash = "sha256-OhJb/q1XJ/U/AvCcCXw2Ll86UKlkHGuURHS5J6aXNTs=";

  subPackages = [ "cmd/gen" ];

  meta = with lib; {
    description = "Implementation of the BARE message format for Go";
    mainProgram = "gen";
    homepage = "https://git.sr.ht/~sircmpwn/go-bare";
    license = licenses.asl20;
    maintainers = with maintainers; [ poptart ];
  };
}
