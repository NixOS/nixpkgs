{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "lk-jwt-service";
  version = "0-unstable-2024-04-27";

  src = fetchFromGitHub {
    owner = "element-hq";
    repo = "lk-jwt-service";
    rev = "4a295044a4d0bd2af4474bf6a8a14fd0596ecf9e";
    hash = "sha256-dN4iJ8P0u5dbZ93mp/FumcvByP7EpQhOvR+Oe4COWXQ=";
  };

  vendorHash = "sha256-9qOApmmOW+N1L/9hj9tVy0hLIUI36WL2TGWUcM3ajeM=";

  postInstall = ''
    mv $out/bin/ec-lms $out/bin/lk-jwt-service
  '';

  meta = with lib; {
    description = "Minimal service to provide LiveKit JWTs using Matrix OpenID Connect";
    homepage = "https://github.com/element-hq/lk-jwt-service";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ kilimnik ];
    mainProgram = "lk-jwt-service";
  };
}
