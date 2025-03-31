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
  version = "3.27.2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    hash = "sha256-rPdo+gj1nxbrE3qbABB7H+tN6WXAdwhtPUCYCsn6vEk=";
    rev = "v${version}";
  };

  vendorHash = "sha256-ckJ9HJkkaDx42wS/j9cwDGOku9X7yZ5uL1bun6IMfH4=";

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
