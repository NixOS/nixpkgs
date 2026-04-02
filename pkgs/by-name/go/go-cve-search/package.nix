{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "go-cve-search";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "s-index";
    repo = "go-cve-search";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gx2No5XGflGY6TIU92gz9XrNDzd4NiSuxpbwxChlqWo=";
  };

  vendorHash = "sha256-QXYjLPrfIPcZE8UTcE1kR9QQIusR/rAJG+e/IQ4P0PU=";

  # Tests requires network access
  doCheck = false;

  meta = {
    description = "Lightweight CVE search tool";
    mainProgram = "go-cve-search";
    longDescription = ''
      go-cve-search is a lightweight tool to search CVE (Common Vulnerabilities
      and Exposures).
    '';
    homepage = "https://github.com/s-index/go-cve-search";
    changelog = "https://github.com/s-index/go-cve-search/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
