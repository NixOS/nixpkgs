{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "scc";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "boyter";
    repo = "scc";
    rev = "v${version}";
    hash = "sha256-7qenc/1FEwiyR7qz6u8L35Wb8zAUVQ5sG5bvYpZKdzs=";
  };

  vendorHash = null;

  # scc has a scripts/ sub-package that's for testing.
  excludedPackages = [ "scripts" ];

  meta = with lib; {
    homepage = "https://github.com/boyter/scc";
    description = "Very fast accurate code counter with complexity calculations and COCOMO estimates written in pure Go";
    maintainers = with maintainers; [
      sigma
      Br1ght0ne
    ];
    license = with licenses; [
      unlicense
      # or
      mit
    ];
  };
}
