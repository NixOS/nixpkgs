{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "addlicense";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "addlicense";
    tag = "v${version}";
    sha256 = "sha256-SM2fPfSqtc6LO+6Uk/sb/IMThXdE8yvk52jK3vF9EfE=";
  };

  vendorHash = "sha256-2mncc21ecpv17Xp8PA9GIodoaCxNBacbbya/shU8T9Y=";

  subPackages = [ "." ];

  meta = {
    description = "Ensures source code files have copyright license headers by scanning directory patterns recursively";
    homepage = "https://github.com/google/addlicense";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "addlicense";
  };
}
