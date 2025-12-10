{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "scc";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${version}";
    hash = "sha256-ec3k6NL3zTYvcJo0bR/BqdTu5br4vRZpgrBR6Kj5YxY=";
  };

  vendorHash = null;

  # scc has a scripts/ sub-package that's for testing.
  excludedPackages = [ "scripts" ];

  meta = with lib; {
    homepage = "https://github.com/boyter/scc";
    description = "Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go";
    maintainers = with maintainers; [
      sigma
    ];
    license = with licenses; [
      mit
    ];
  };
}
