{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hcledit";
  version = "0.2.19";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = "hcledit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hX3ioyzZFdas4aPE6/fdxevA3leAn9foYiuoIzkfYA0=";
  };

  vendorHash = "sha256-3LNpAj0R0wI3Mhs7wryt2S5AWEt+UQ28tDrAQl20PK8=";

  meta = {
    description = "Command line editor for HCL";
    mainProgram = "hcledit";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aleksana ];
  };
})
