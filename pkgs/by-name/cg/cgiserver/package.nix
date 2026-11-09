{
  lib,
  buildGoModule,
  fetchzip,
  zstd,
}:

buildGoModule (finalAttrs: {
  pname = "cgiserver";
  version = "1.0.0";

  src = fetchzip {
    url = "https://src.anomalous.eu/cgiserver/snapshot/cgiserver-${finalAttrs.version}.tar.zst";
    nativeBuildInputs = [ zstd ];
    hash = "sha256-uIrOZbHzxAdUJF12MBOzRUA6mSPvOKJ/K9ZwwLVId5E=";
  };

  vendorHash = "sha256-mygMtVbNWwtIkxTGxMnuAMUU0mp49NZ50B9d436nWgI=";

  meta = {
    homepage = "https://src.anomalous.eu/cgiserver/about/";
    description = "Lightweight web server for sandboxing CGI applications";
    mainProgram = "cgiserver";
    maintainers = with lib.maintainers; [ qyliss ];
    license = lib.licenses.osl3;
  };
})
