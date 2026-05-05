{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "pup";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "gromgit";
    repo = "pup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FnMPrgALABCQ9WKYEqEvB7guKHyYaXa3nU4jxZILzYw=";
  };

  vendorHash = "sha256-VoCot34BhtrY0bjgm1z6LBbtsiBdw7fjLqVB3/hxTlM=";

  updateScript = nix-update-script { };

  meta = {
    description = "Parsing HTML at the command line (gromgit fork)";
    mainProgram = "pup";
    homepage = "https://github.com/gromgit/pup";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
  };
})
