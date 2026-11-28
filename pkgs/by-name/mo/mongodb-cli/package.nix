{
  stdenv,
  fetchFromGitHub,
  lib,
  buildGoModule,
  installShellFiles,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "mongodb-cli";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongodb-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ECR2o4CafGnpAzMvLcYjBBEvMkU3xrbdFIa3hRyjzH4=";
  };

  vendorHash = "sha256-0bZ/JfNtFr26UvMnXPMSf36I7TBA53nzPig7MUzOOEI=";

  subPackages = [ "cmd/mongocli" ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion --cmd mongocli "--$shell" <("$out/bin/mongocli" completion "$shell")
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage your MongoDB via ops manager and cloud manager";
    homepage = "https://github.com/mongodb/mongodb-cli";
    changelog = "https://www.mongodb.com/docs/mongocli/current/release-notes/#mongodb-cli-${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.iamanaws ];
    mainProgram = "mongocli";
  };
})
