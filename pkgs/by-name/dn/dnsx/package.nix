{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dnsx";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-325pwIcI8YjHA1K+gF3NA1LCP9dyZRJW4eKxm2AQyB8=";
  };

  vendorHash = "sha256-ep9IN/aPWy4N5HADh4U5T6XeBnm0YB5Tv8yeaqBxZi0=";

  subPackages = [ "cmd/dnsx" ];

  ldflags = [ "-s" ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Fast and multi-purpose DNS toolkit";
    longDescription = ''
      dnsx is a fast and multi-purpose DNS toolkit allow to run multiple
      probers using retryabledns library, that allows you to perform
      multiple DNS queries of your choice with a list of user supplied
      resolvers.
    '';
    homepage = "https://github.com/projectdiscovery/dnsx";
    changelog = "https://github.com/projectdiscovery/dnsx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "dnsx";
  };
})
