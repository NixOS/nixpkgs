{
  lib,
  fetchFromGitHub,
  buildGoModule,
  libwebp,
}:
buildGoModule rec {
  pname = "http3-ytproxy";
  version = "unstable-2022-07-03";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = pname;
    rev = "4059da180bb9d7b0de10c1a041bd0e134f1b6408";
    hash = "sha256-ilIOkZ9lcuSigh/mMU7IGpWlFMFb2/Y11ri3659S8+I=";
  };

  patches = [
    # this patch was created by updating the quic-go dependency, bumping the go version
    # and running `go mod tidy`
    ./dependencies.patch
  ];

  vendorHash = "sha256-17y+kxlLSqCFoxinNNKzg7IqGpbiv0IBsUuC9EC8xnk=";

  buildInputs = [ libwebp ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "YouTube traffic proxy for video playback and images";
    homepage = "https://github.com/TeamPiped/http3-ytproxy";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ _999eagle ];
    mainProgram = "http3-ytproxy";
  };
}
