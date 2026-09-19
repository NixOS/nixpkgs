{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "SpoofDPI";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FL/8BfEBPhCZWV0PMrMFibXc5g3GtHbj9iHvuZuO4wU=";
  };

  vendorHash = "sha256-EJBkjT/JqVap/vuL4yp3Jm+6lnHnnYtwmvi8uTvrZsE=";

  meta = {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "Simple and fast anti-censorship tool written in Go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
  };
})
