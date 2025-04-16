{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "hours";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "hours";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B9M02THTCrr7ylbbflpkpTFMuoIwV2O0PQKOKbyxYPg=";
  };

  vendorHash = "sha256-5lhn0iTLmXUsaedvtyaL3qWLosmQaQVq5StMDl7pXXI=";

  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "No-frills time tracking toolkit for command line nerds";
    homepage = "https://github.com/dhth/hours";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ilarvne ];
    platforms = lib.platforms.unix;
    mainProgram = "hours";
  };
})
