{
  lib,
  buildGoModule,
  fetchFromGitHub,
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

  meta = {
    description = "CLI HTML parser";
    mainProgram = "pup";
    homepage = "https://github.com/gromgit/pup";
    changelog = "https://github.com/gromgit/pup/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.giorgiga ];
  };
})
