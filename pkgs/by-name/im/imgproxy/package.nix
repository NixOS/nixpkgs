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
  version = "3.31.2";

  src = fetchFromGitHub {
    owner = "imgproxy";
    repo = "imgproxy";
    hash = "sha256-gKSSdBtmCSiiBPon3Fj+TGyGSITND5C+hUW9xdjJPZs=";
    rev = "v${finalAttrs.version}";
  };

  vendorHash = "sha256-coHlsBh+ujEU9D/RloONAl+TDaxEJMdvvaNEuWe4SP8=";

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
