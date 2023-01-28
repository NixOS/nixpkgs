{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "todiff";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "Ekleog";
    repo = "todiff";
    rev = version;
    sha256 = "1y0v8nkaqb8kn61xwarpbyrq019gxx1f5f5p1hzw73nqxadc1rcm";
  };

  cargoSha256 = "0vrn1vc3rwabv6l2r1qb7mkcxbp75q79bfl3rxhyi51ra3ij507r";

  checkFeatures = [ "integration_tests" ];

  meta = with lib; {
    description = "Human-readable diff for todo.txt files";
    homepage = "https://github.com/Ekleog/todiff";
    maintainers = with maintainers; [ ekleog ];
    license = licenses.mit;
  };
}
