{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:
let
  pname = "fmd-server";
  version = "0.13.0";

  src = fetchFromGitLab {
    owner = "fmd-foss";
    repo = "fmd-server";
    tag = "v${version}";
    hash = "sha256-pIVsdoen45YWG/V8qW/DE/yet4o+8MqpVHgHh70Fty8=";
  };
in
buildGoModule {
  inherit pname version src;

  vendorHash = "sha256-d8QP6k7vEX0jBcpIMZymgOFYyKqGhND4Xa+mANg172s=";

  meta = {
    description = "Server to communicate with the FindMyDevice app and save the latest (encrypted) location";
    homepage = "https://fmd-foss.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ j0hax ];
    mainProgram = "fmd-server";
  };
}
