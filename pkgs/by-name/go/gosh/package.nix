{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gosh";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "GoSH";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h4WqaN2okAeaU/+0fs8zLYDtyQLuLkCDdGrkGz8rdhg=";
  };

  vendorHash = "sha256-ITz6nkhttG6bsIZLsp03rcbEBHUQ7pFl4H6FOHTXIU4=";

  subPackages = [ "." ];

  meta = {
    description = "Reverse/bind shell generator";
    homepage = "https://github.com/redcode-labs/GoSH";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "GoSH";
  };
})
