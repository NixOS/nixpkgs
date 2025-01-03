{ lib
, buildGoModule
, fetchFromGitHub
, curl
, stdenv
, testers
, static-server
, substituteAll
}:

buildGoModule rec {
  pname = "static-server";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "eliben";
    repo = "static-server";
    rev = "v${version}";
    hash = "sha256-AZcNh/kF6IdAceA7qe+nhRlwU4yGh19av/S1Zt7iKIs=";
  };

  vendorHash = "sha256-1p3dCLLo+MTPxf/Y3zjxTagUi+tq7nZSj4ZB/aakJGY=";

  patches = [
    # patch out debug.ReadBuidlInfo since version information is not available with buildGoModule
    (substituteAll {
      src = ./version.patch;
      inherit version;
    })
  ];

  nativeCheckInputs = [
    curl
  ];

  ldflags = [ "-s" "-w" ];

  # tests sometimes fail with SIGQUIT on darwin
  doCheck = !stdenv.isDarwin;

  passthru.tests = {
    version = testers.testVersion {
      package = static-server;
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Simple, zero-configuration HTTP server CLI for serving static files";
    homepage = "https://github.com/eliben/static-server";
    license = licenses.unlicense;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "static-server";
  };
}
