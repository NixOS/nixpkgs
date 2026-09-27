{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "hermit";
  version = "0.53.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "cashapp";
    repo = "hermit";
    hash = "sha256-yhKvRgrX4pN21kXUU0qZGnenVtWlT3tnsKWZ4Iu8wb0=";
  };

  vendorHash = "sha256-2sj1Tc+3icoOPKq1hcOxSjKarxQ7Vvvvx9iAWWrb3Xo=";

  subPackages = [ "cmd/hermit" ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.channel=stable"
  ];

  meta = {
    homepage = "https://cashapp.github.io/hermit";
    description = "Manages isolated, self-bootstrapping sets of tools in software projects";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cbrewster ];
    platforms = lib.platforms.unix;
    mainProgram = "hermit";
  };
})
