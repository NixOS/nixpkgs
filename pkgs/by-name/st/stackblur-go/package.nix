{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "stackblur-go";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "esimov";
    repo = "stackblur-go";
    rev = "v${version}";
    hash = "sha256-y1Fov81mholhz+bLRYl+G7jhzcsFS5TUjQ3SUntD8E0=";
  };

  vendorHash = null;

  postInstall = ''
    mv $out/bin/cmd $out/bin/stackblur
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Fast, almost Gaussian Blur implementation in Go";
    homepage = "https://github.com/esimov/stackblur-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sodiboo ];
    mainProgram = "stackblur";
  };
}
