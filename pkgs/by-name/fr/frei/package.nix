{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "frei";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "alexcoder04";
    repo = "frei";
    rev = "v${version}";
    sha256 = "sha256-289idsn/PhLK2FOUTQj6eS4O73LgX5v5qn3ZRvn/XRo=";
  };

  vendorHash = "sha256-N5k/2wB46oRfM4ShjVQ23tAgCMmyBaGfIslUqYUJYrc=";

  meta = with lib; {
    description = "Modern replacement for free";
    homepage = "https://github.com/alexcoder04/frei";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "frei";
  };
}
