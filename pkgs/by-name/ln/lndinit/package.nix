{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "lndinit";
  version = "0.1.26-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lndinit";
    rev = "v${version}";
    hash = "sha256-Mqb7dclVQWiQCRO42ama3c5Gn3ZREK8HsjOJSk6Iguw=";
  };

  vendorHash = "sha256-ZmggWcI8RsWV17o8yfimbuIDDr7s15rdQFETTyj+83c=";

  subPackages = [ "." ];

  meta = {
    description = "Wallet initializer utility for lnd";
    homepage = "https://github.com/lightninglabs/lndinit";
    mainProgram = "lndinit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
}
