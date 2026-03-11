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

buildGoModule (finalAttrs: {
  pname = "imgproxy";
  version = "3.30.1";

  src = fetchFromGitHub {
    owner = "imgproxy";
    repo = "imgproxy";
    hash = "sha256-UaJ02TQ8jbebRDF5K3zFy+4ho+dt1o/o3cEDzUQY3iU=";
    rev = "v${finalAttrs.version}";
  };

  vendorHash = "sha256-0NIsaSMOBenDCGvnGdLB60sp08EaC/CezWogxTrcDdY=";

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  buildInputs = [ vips ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libunwind ];

  preBuild = ''
    export CGO_LDFLAGS_ALLOW='-(s|w)'
  '';

  meta = {
    description = "Fast and secure on-the-fly image processing server written in Go";
    mainProgram = "imgproxy";
    homepage = "https://imgproxy.net";
    changelog = "https://github.com/imgproxy/imgproxy/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paluh ];
  };
})
