{
  lib,
  buildGoModule,
  fetchFromGitHub,
  curl,
  stdenv,
  testers,
  static-server,
  replaceVars,
}:

buildGoModule (finalAttrs: {
  pname = "static-server";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "eliben";
    repo = "static-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AZcNh/kF6IdAceA7qe+nhRlwU4yGh19av/S1Zt7iKIs=";
  };

  vendorHash = "sha256-1p3dCLLo+MTPxf/Y3zjxTagUi+tq7nZSj4ZB/aakJGY=";

  patches = [
    # patch out debug.ReadBuidlInfo since version information is not available with buildGoModule
    (replaceVars ./version.patch {
      inherit (finalAttrs) version;
    })
  ];

  nativeCheckInputs = [
    curl
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  # tests sometimes fail with SIGQUIT on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.tests = {
    version = testers.testVersion {
      package = static-server;
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Simple, zero-configuration HTTP server CLI for serving static files";
    homepage = "https://github.com/eliben/static-server";
    license = lib.licenses.unlicense;
    maintainers = [ ];
    mainProgram = "static-server";
  };
})
