{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "simplotask";
<<<<<<< HEAD
  version = "1.19.2";
=======
  version = "1.19.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "umputun";
    repo = "spot";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-UFuHcva5+0KMaIas6N+Ny1Ego6ZI+J8gd+91EisRlXM=";
=======
    hash = "sha256-Zu7GkvNVhf6TeZg2AVH8GTi5ORK5aUspSvB1ThOBwTo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
