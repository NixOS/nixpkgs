{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule {
  pname = "primitive";
  version = "0-unstable-2020-05-04";

  src = fetchFromGitHub {
    owner = "fogleman";
    repo = "primitive";
    rev = "0373c216458be1c4b40655b796a3aefedf8b7d23";
    hash = "sha256-stKb3tPP/pgHTfdyTmWwVj/hLjOHtFpvJxXgBhhWgPQ=";
  };
  vendorHash = "sha256-I3rhP87QJJxNM9D7JYo3BjG/1PhsDWbnK/NJTf4aqmI=";

  patches = [
    (fetchpatch {
      name = "add-modules.patch";
      url = "https://github.com/regularpoe/primitive/commit/2fa9b9f575ac2602e771c5263747bdbb48e9810b.patch";
      hash = "sha256-TX3dGqVuY+qLh9EBg7oNVYWhGuETZHJdjPTroCDyZ74=";
    })
  ];

  meta = {
    description = "Reproducing images with geometric primitives";
    homepage = "https://github.com/fogleman/primitive";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stunkymonkey ];
    mainProgram = "primitive";
    platforms = lib.platforms.all;
  };
}
