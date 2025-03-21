{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "lk-jwt-service";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${version}";
    hash = "sha256-R4YqmHp0i+RpJJkENJPZJDNCVg+O+70JMoCR8ZlesyM=";
  };

  vendorHash = "sha256-evzltyQZCBQ4/k641sQrmUvw6yIBWFEic/WUa/WX5xE=";

  meta = with lib; {
    description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
    homepage = "https://github.com/element-hq/lk-jwt-service";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "lk-jwt-service";
  };
}
