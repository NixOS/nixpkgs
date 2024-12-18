{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "go-org";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "niklasfasching";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BPCQxl0aJ9PrEC5o5dc5uBbX8eYAxqB+qMLXo1LwCoA=";
  };

  vendorHash = "sha256-HbNYHO+tqFEs9VXdxyA+r/7mM/p+NBn8PomT8JAyKR8=";

  postInstallCheck = ''
    $out/bin/go-org > /dev/null
  '';

  meta = with lib; {
    description = "Org-mode parser and static site generator in go";
    homepage = "https://niklasfasching.github.io/go-org";
    license = licenses.mit;
    maintainers = with maintainers; [ bhankas ];
    mainProgram = "go-org";
  };
}
