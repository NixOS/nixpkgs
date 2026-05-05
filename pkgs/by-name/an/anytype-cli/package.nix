{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  tantivy-go,
}:
buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "anytype-cli";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-cli";
    rev = "187c066c080c0ef4d535aeb7ec23370f15ed17e3";
    hash = "sha256-xbukPdGXtITO3GtQz+7zz1o/k5rjtVqy42yINANPKUk=";
  };

  vendorHash = "sha256-PxD+2flqelGFMCrpRU6iOEasMf24YKkoPd0gUSowQwA=";
  proxyVendor = true;

  env.CGO_ENABLED = 1;
  env.CGO_LDFLAGS = "-L${tantivy-go}/lib";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/anyproto/anytype-cli/core.Version=v${finalAttrs.version}"
  ];

  meta = with lib; {
    description = "Command-line interface for interacting with Anytype";
    homepage = "https://github.com/anyproto/anytype-cli";
    license = licenses.mit;
    mainProgram = "anytype-cli";
    platforms = platforms.linux ++ platforms.darwin;
  };
})
