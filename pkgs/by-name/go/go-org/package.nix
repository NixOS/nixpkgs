{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "go-org";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "niklasfasching";
    repo = "go-org";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BPCQxl0aJ9PrEC5o5dc5uBbX8eYAxqB+qMLXo1LwCoA=";
  };

  vendorHash = "sha256-HbNYHO+tqFEs9VXdxyA+r/7mM/p+NBn8PomT8JAyKR8=";

  postInstallCheck = ''
    $out/bin/go-org > /dev/null
  '';

  meta = {
    description = "Org-mode parser and static site generator in go";
    homepage = "https://niklasfasching.github.io/go-org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bhankas ];
    mainProgram = "go-org";
  };
})
