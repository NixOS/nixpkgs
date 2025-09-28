{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.11.0";
in

buildGoModule {
  pname = "agola";
  inherit version;

  src = fetchFromGitHub {
    owner = "agola-io";
    repo = "agola";
    tag = "v${version}";
    hash = "sha256-rRx+N1wuc2YztddQiaoijhkdTilt5Nsp1ZoyByg08vE=";
  };

  vendorHash = "sha256-pNrulS7cjeSQyFJODOrxZvOLam56PLZz8jdFzONzbvA=";

  ldflags = [
    "-s"
    "-w"
    "-X agola.io/agola/cmd.Version=${version}"
  ];

  tags = [
    "sqlite_unlock_notify"
  ];

  # somehow the tests get stuck
  doCheck = false;

  meta = with lib; {
    description = "CI/CD Redefined";
    homepage = "https://agola.io";
    maintainers = with maintainers; [ happysalada ];
    license = licenses.mit;
  };
}
