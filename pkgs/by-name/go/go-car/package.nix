{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "go-car";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "ipld";
    repo = "go-car";
    tag = "v${finalAttrs.version}";
    hash = "sha256-votPngF8qpX/6vZcsmDM/I5Vb3wASvuKduBjJi0eQ2w=";
  };

  modRoot = "cmd";
  subPackages = [ "car" ];

  vendorHash = "sha256-uzzSw51FoAdHPqqoMY2C/zx1nHbbii6izzTjguYYghs=";

  buildInputs = [ libpcap ];

  ldflags = [ "-s" ];

  meta = {
    description = "Content addressable archive utility";
    homepage = "https://github.com/ipld/go-car";
    changelog = "https://github.com/ipld/go-car/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "car";
  };
})
