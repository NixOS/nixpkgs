{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  vips,
  gobject-introspection,
  stdenv,
  libunwind,
}:

buildGoModule rec {
  pname = "imgproxy";
  version = "3.29.0";

  src = fetchFromGitHub {
    owner = "imgproxy";
    repo = "imgproxy";
    hash = "sha256-uqJzAD2Zawrb06++IwGsfH4wTctsS+4xNynPHTrHSx8=";
    rev = "v${version}";
  };

  vendorHash = "sha256-8gXFGcS4RWbXmWSdDfZjgn6y7POTmrTAsXFERj3ttJo=";

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  buildInputs = [ vips ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libunwind ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = with lib; {
    description = "Fast and secure on-the-fly image processing server written in Go";
    mainProgram = "imgproxy";
    homepage = "https://imgproxy.net";
    changelog = "https://github.com/imgproxy/imgproxy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ paluh ];
  };
}
