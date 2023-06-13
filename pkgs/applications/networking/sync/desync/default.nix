{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "desync";
  version = "0.9.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "folbricht";
    repo = "desync";
    sha256 = "sha256-vyW5zR6Dw860LUj7sXFgwzU1AZDoPMoQ4G0xsK4L6+w=";
  };

  vendorSha256 = "sha256-RMM/WFIUg2Je3yAgshif3Nkhm8G3bh6EhHCHTAvMXUc=";

  # nix builder doesn't have access to test data; tests fail for reasons unrelated to binary being bad.
  doCheck = false;

  meta = with lib; {
    description = "Content-addressed binary distribution system";
    longDescription = "An alternate implementation of the casync protocol and storage mechanism with a focus on production-readiness";
    homepage = "https://github.com/folbricht/desync";
    license = licenses.bsd3;
    maintainers = [ maintainers.chaduffy ];
  };
}
