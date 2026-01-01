{
  lib,
<<<<<<< HEAD
  fetchFromGitHub,

  go,
  buildGoModule,

  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "node-cert-exporter";
  version = "1.1.7-unstable-2025-03-10";
=======
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "node-cert-exporter";
  version = "1.1.7-unstable-2024-12-26";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "amimof";
    repo = "node-cert-exporter";
<<<<<<< HEAD
    rev = "eef1b8207b5fdb4d6690fcfa543caf823cff0754";
    hash = "sha256-/z2wQmcCEsPKEMKj7OunD0e+9OvXv6NV6Bn8myW6HLk=";
  };

=======
    rev = "v1.1.7";
    sha256 = "sha256-VYJPgNVsfEs/zh/SEdOrFn0FK6S+hNFGDhonj2syutQ=";
  };

  vendorHash = "sha256-31MHX3YntogvoJmbOytl0rXS6qtdBSBJe8ejKyu6gqM=";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # Required otherwise we get a few:
  # vendor/github.com/golang/glog/internal/logsink/logsink.go:129:41:
  # predeclared any requires go1.18 or later (-lang was set to go1.16; check go.mod)
  patches = [ ./gomod.patch ];

<<<<<<< HEAD
  vendorHash = "sha256-Y/JgjWb2eFe4aCTU/v05rB5xH9TgZgZt2WITalj1nwc=";

  ldflags = [
    "-s"
    "-X main.VERSION=${finalAttrs.version}"
    "-X main.COMMIT=${finalAttrs.src.rev}"
    "-X main.BRANCH=master"
    "-X main.GOVERSION=${go.version}"
  ];

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Prometheus exporter for SSL certificate";
    homepage = "https://github.com/amimof/node-cert-exporter";
    license = lib.licenses.asl20;
    mainProgram = "node-cert-exporter";
    maintainers = with lib.maintainers; [ ibizaman ];
  };
})
=======
  meta = {
    description = "Prometheus exporter for SSL certificate";
    mainProgram = "node-cert-exporter";
    homepage = "https://github.com/amimof/node-cert-exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ibizaman ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
