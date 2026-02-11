{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-bindata";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "kevinburke";
    repo = "go-bindata";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3/1RqJrv1fsPKsZpurp2dHsMg8FJBcFlI/pwwCf5H6E=";
  };

  vendorHash = null;

  subPackages = [ "go-bindata" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    homepage = "https://github.com/kevinburke/go-bindata";
    changelog = "https://github.com/kevinburke/go-bindata/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Small utility which generates Go code from any file, useful for embedding binary data in a Go program";
    mainProgram = "go-bindata";
    maintainers = [ ];
    license = lib.licenses.cc0;
  };
})
