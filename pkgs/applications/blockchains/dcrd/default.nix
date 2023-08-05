{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dcrd";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "decred";
    repo = "dcrd";
    rev = "refs/tags/release-v${version}";
    hash = "sha256-ZNBSIzx07zJrBxas7bHpZ8ZPDWJ4d7jumpKYj5Qmzlo=";
  };

  vendorHash = "sha256-++IPB2IadXd1LC5r6f1a0UqsTG/McAf7KQAw8WKKoaE=";

  subPackages = [ "." "cmd/promptsecret" ];

  meta = {
    homepage = "https://decred.org";
    description = "Decred daemon in Go (golang)";
    license = with lib.licenses; [ isc ];
    maintainers = with lib.maintainers; [ juaningan ];
  };
}
