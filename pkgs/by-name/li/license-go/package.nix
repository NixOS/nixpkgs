{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "5.0.4";
in
buildGoModule {
  pname = "license-go";
  inherit version;

  src = fetchFromGitHub {
    owner = "nishanths";
    repo = "license";
    rev = "v${version}";
    hash = "sha256-Rz/eIGa3xLjirPMOs4otfmwy4OzJgopKPbka2OKt8Fo=";
  };

  vendorHash = "sha256-kx3lPhmEo515sHgHBqDC6udz6xkZvB+nn6x3/JaBHbo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  meta = {
    description = "Command line license text generator";
    homepage = "https://github.com/nishanths/license";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ uncenter ];
    mainProgram = "license";
  };
}
