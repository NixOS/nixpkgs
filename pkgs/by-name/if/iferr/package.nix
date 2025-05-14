{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "iferr";
  version = "0-unstable-2024-01-22";

  src = fetchFromGitHub {
    owner = "koron";
    repo = "iferr";
    rev = "9c3e2fbe4bd19a7f0338e42bb483562ed4cf4d50";
    hash = "sha256-qGuSsdQorb407rDl2o7w7kPCLng3W7YQsqo5JpoZFW8=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = ''Generate "if err != nil {" block'';
    homepage = "https://github.com/koron/iferr";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "iferr";
  };
}
