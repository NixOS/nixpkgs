{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "papeer";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "lapwat";
    repo = "papeer";
    rev = "v${version}";
    hash = "sha256-9cHbXo/kpe9S6MQE4wzgCZ4+m9gwGmckRmNhI+1zrS8=";
  };

  vendorHash = "sha256-ZPkaS2obfeWS5/tWSkDe+Lua95mvoNXeNx3JEXrx/Es=";

  doCheck = false; # uses network

  meta = {
    description = "Convert websites into ebooks and markdown";
    mainProgram = "papeer";
    homepage = "https://papeer.tech/";
    license = lib.licenses.gpl3Plus;
  };
}
