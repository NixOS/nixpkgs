{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lndinit";
  version = "0.1.36-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "lndinit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2rFiDy1yVXqI0ag8fsifx9sCCu0BbwSj9U7bzU352dc=";
  };

  vendorHash = "sha256-vLatsVG4VUtSAJtOiZgy4zWdh9Qs4cwkz0CaUTRZ3oE=";

  subPackages = [ "." ];

  meta = {
    description = "Wallet initializer utility for lnd";
    homepage = "https://github.com/lightninglabs/lndinit";
    mainProgram = "lndinit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
})
