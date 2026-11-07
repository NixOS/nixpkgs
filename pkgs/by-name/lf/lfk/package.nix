{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "lfk";
  version = "0.16.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "janosmiko";
    repo = "lfk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3aOfxvTctaOT4dO6JxvNZXK6vGCRnb1O5N/7Nr8yz7E=";
  };

  vendorHash = "sha256-wmM3qWzNnb4zis5JhZNd2iXV6gzy1dMagADYh/hzKuc=";

  ldflags = [ "-s" ];

  meta = {
    description = "Lightning Fast Kubernetes navigator";
    longDescription = "LFK is a lightning-fast, keyboard-focused, yazi-inspired terminal user interface for navigating and managing Kubernetes clusters. Built for speed and efficiency, it brings a three-column Miller columns layout with an owner-based resource hierarchy to your terminal";
    homepage = "https://github.com/janosmiko/lfk";
    changelog = "https://github.com/janosmiko/lfk/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "lfk";
  };
})
