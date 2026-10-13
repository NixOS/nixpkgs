{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "jp";
  version = "0.2.1";

  src = fetchFromGitHub {
    rev = finalAttrs.version;
    owner = "jmespath";
    repo = "jp";
    hash = "sha256-a3WvLAdUZk+Y+L+opPDMBvdN5x5B6nAi/lL8JHJG/gY=";
  };

  vendorHash = "sha256-K6ZNtART7tcVBH5myV6vKrKWfnwK8yTa6/KK4QLyr00=";

  meta = {
    description = "Command line interface to the JMESPath expression language for JSON";
    mainProgram = "jp";
    homepage = "https://github.com/jmespath/jp";
    maintainers = with lib.maintainers; [ cransom ];
    license = lib.licenses.asl20;
  };
})
