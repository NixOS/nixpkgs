{
  lib,
  buildGoModule,
  fetchFromGitHub,

  go-bindata,
  makeWrapper,
}:

buildGoModule rec {
  pname = "go-bindata-assetfs";
  version = "unstable-2025-02-01";

  src = fetchFromGitHub {
    owner = "elezarl";
    repo = "go-bindata-assetfs";
    rev = "d06c361cdac6293509ed6ecb3d8ef0d46066a0f7";
    hash = "sha256-rLeQbcv6V0Uc8iBEGMMnqxXcDJ2e91K96ZeYEYG6UCI=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    go-bindata
    makeWrapper
  ];
  postInstall = ''
    wrapProgram $out/bin/go-bindata-assetfs \
      --prefix PATH : ${go-bindata}/bin
  '';

  meta = with lib; {
    description = "Serve embedded files from jteeuwen/go-bindata";
    mainProgram = "go-bindata-assetfs";
    license = licenses.bsd2;
    maintainers = with maintainers; [ avnik ];
  };
}
