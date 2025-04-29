{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  distribution,
}:

buildGoModule (finalAttrs: {
  pname = "distribution";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "distribution";
    repo = "distribution";
    tag = "v${finalAttrs.version}";
    hash = "sha256-myezQTEdH7kkpCoAeZMf5OBxT4Bz8Qx6vCnwim230RY=";
  };

  vendorHash = null;

  checkFlags = [
    # TestHTTPChecker: requires internet access.
    # TestInMemoryDriverSuite: timeout after 10 minutes, looks like a deadlock.
    "-skip=^TestHTTPChecker$|^TestInMemoryDriverSuite$"
  ];
  __darwinAllowLocalNetworking = true;

  passthru = {
    tests.version = testers.testVersion {
      package = distribution;
      version = "v${finalAttrs.version}";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Toolkit to pack, ship, store, and deliver container content";
    longDescription = ''
      Distribution is a Open Source Registry implementation for storing and distributing container
      images and other content using the OCI Distribution Specification. The goal of this project
      is to provide a simple, secure, and scalable base for building a large scale registry solution
      or running a simple private registry.
    '';
    homepage = "https://distribution.github.io/distribution/";
    changelog = "https://github.com/distribution/distribution/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ katexochen ];
    mainProgram = "registry";
    platforms = platforms.unix;
  };
})
