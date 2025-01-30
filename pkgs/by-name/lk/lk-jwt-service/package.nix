{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "lk-jwt-service";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    tag = "v${version}";
    hash = "sha256-RbfJdAhLz2wfTC17i533U25TIUtJEkHTgqJC2R+j1uM=";
  };

  vendorHash = "sha256-7wruthAqC9jVpAhPiIDdqAB51l38fLHEhl2QOaBJiL0=";

  meta = with lib; {
    description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
    homepage = "https://github.com/element-hq/lk-jwt-service";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "lk-jwt-service";
  };
}
