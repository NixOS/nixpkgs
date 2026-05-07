{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "lfk";
  version = "0.10.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "janosmiko";
    repo = "lfk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6H67d9zVdfsUhnsC4Hg6z3nm0w2//Q8oj1FZBR+a8SY=";
  };

  vendorHash = "sha256-GfJr3jtG+GhV7AHgM0EjPe+bFqdIRkHpjaylu753cGI=";

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
