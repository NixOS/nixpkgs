{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gomtree";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "vbatts";
    repo = "go-mtree";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MLZybHyYxRxxRy0/pd1n8apcfzrNVu2joP2S2P4KRHU=";
  };

  vendorHash = null;

  # test fails with nix due to ro file system
  checkFlags = [ "-skip=^TestXattr$" ];

  subPackages = [ "cmd/gomtree" ];

  ldflags = [
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "File systems verification utility and library, in likeness of mtree(8)";
    changelog = "https://github.com/vbatts/go-mtree/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/vbatts/go-mtree";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "gomtree";
  };
})
