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
  version = "3.26.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    hash = "sha256-r8yczisCN2jfWFc0L+EIgJLw5MPK4r5+lJsW6FM2hUY=";
    rev = "v${version}";
  };

  vendorHash = "sha256-LGQ+JJ3OqDisT+CsnseVO54wyRTOkGpG9/zzpJw9P1I=";

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
