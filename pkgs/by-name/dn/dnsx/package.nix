{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "dnsx";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "dnsx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PYcrpcr6VfoqKh48uXtgxyBolXj/BtD9fSCMl9miBCc=";
  };

  vendorHash = "sha256-KwZQG/rMKtu+6j7QzPTzLIGtY+fs+zVmrtaQCY1nTOg=";

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
