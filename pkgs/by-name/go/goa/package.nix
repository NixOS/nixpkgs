{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.20.1";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-+MAK/qRvwMfjifeXmBjDWKmQ75LAbIUjZ6rvqw1Xv3I=";
  };
  vendorHash = "sha256-/5tcIvJpJPVMOL6XBAjXbiHeCwpB0YOLv5hRhd5zG7Q=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
