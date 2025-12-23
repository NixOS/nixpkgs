{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "allmark";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "andreaskoch";
    repo = "allmark";
    tag = "v${version}";
    hash = "sha256-JfNn/e+cSq1pkeXs7A2dMsyhwOnh7x2bwm6dv6NOjLU=";
  };

  vendorHash = "sha256-dEmI+COrWhXdqtTkLIjyiUapHtjezCEuY9jLDqxkBBg=";

  deleteVendor = true;

  patches = [
    ./0001-Add-go.mod-go.sum.patch # Add go.mod, go.sum, remove vendor
  ];

  postInstall = ''
    mv $out/bin/{cli,allmark}
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Cross-platform markdown web server";
    homepage = "https://github.com/andreaskoch/allmark";
    changelog = "https://github.com/andreaskoch/allmark/-/releases/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      urandom
    ];
    mainProgram = "allmark";
  };
}
