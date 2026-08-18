{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "lightning-loop";
  version = "0.34.0-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PR5LUqeN1f1XpL9woAZV4foimtFILyZsRKVfhLBf+fQ=";
  };

  vendorHash = "sha256-2563+dXeV81PnBc0FAzUNTKvnwYooKVPGQZdcp5O9Lg=";

  subPackages = [
    "cmd/loop"
    "cmd/loopd"
  ];

  env.CGO_ENABLED = 0;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    installManPage docs/loop.1
  '';

  meta = {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      proofofkeags
      starius
    ];
  };
})
