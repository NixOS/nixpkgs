{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "papeer";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = "papeer";
    rev = "v${version}";
    hash = "sha256-dkOLlWeG6ixbqLJU/1x2R1meKpcXb63C8EXH5FlD38k=";
  };

  vendorHash = "sha256-3QRSdkx9p0H+zPB//bpWCBKKjKjrx0lHMk5lFm+U7pA=";

  doCheck = false; # uses network

  meta = {
    description = "Convert websites into ebooks and markdown";
    mainProgram = "papeer";
    homepage = "https://papeer.tech/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
