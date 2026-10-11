{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-realname-diff";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hhiroshell";
    repo = "kubectl-realname-diff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ej0O5tcHdXHzDSf6aHLgyeYGRv5RbXJMZcyHDyRjLV4=";
  };

  vendorHash = "sha256-XJZ9/JKj+WT3TffNP1Z0y5jws2wqZotzzV/1pk+AJkU=";

  subPackages = [ "cmd/kubectl-realname_diff" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Diff live and local resources ignoring Kustomize suffixes";
    mainProgram = "kubectl-realname_diff";
    homepage = "https://github.com/hhiroshell/kubectl-realname-diff";
    changelog = "https://github.com/hhiroshell/kubectl-realname-diff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.tboerger ];
  };
})
