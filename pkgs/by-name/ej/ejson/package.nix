{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ejson";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Shopify";
    repo = "ejson";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Tkr/o2hjbUiaoTBPesQ+ZIPeJteS/rsqGJBo2dvfqEc=";
  };

  vendorHash = "sha256-vT9A4d+e+iOie5TNbu5EyPi5OZJ/m8Not3tCQc7Xwn8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Small library to manage encrypted secrets using asymmetric encryption";
    mainProgram = "ejson";
    license = lib.licenses.mit;
    homepage = "https://github.com/Shopify/ejson";
  };
})
