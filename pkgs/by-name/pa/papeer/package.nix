{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "papeer";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wUlvv7kXDr33tJuaMm+V68qQZMWEHyXPBkwRKQhqthY=";
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
