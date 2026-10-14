{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lndinit";
  version = "0.1.38-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lndinit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O1sC6wFqfnC9sKsiNBurPI/vhJugmOJjG/7MLVrp0cQ=";
  };

  vendorHash = "sha256-Z/7PFoyTcZv6+T4fbNffXOPfeIP8f4+WEjFwDqMJutU";

  subPackages = [ "." ];

  meta = {
    description = "Wallet initializer utility for lnd";
    homepage = "https://github.com/lightninglabs/lndinit";
    mainProgram = "lndinit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
})
