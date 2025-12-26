{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "simplotask";
  version = "1.19.2";

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "spot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UFuHcva5+0KMaIas6N+Ny1Ego6ZI+J8gd+91EisRlXM=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s -w"
    "-X main.revision=v${finalAttrs.version}"
  ];

  doCheck = false;

  postInstall = ''
    mv $out/bin/{secrets,spot-secrets}
    installManPage *.1
  '';

  meta = {
    description = "Tool for effortless deployment and configuration management";
    homepage = "https://spot.umputun.dev/";
    maintainers = with lib.maintainers; [ sikmir ];
    license = lib.licenses.mit;
    mainProgram = "spot";
  };
})
