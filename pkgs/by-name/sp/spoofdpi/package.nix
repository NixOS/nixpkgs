{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "SpoofDPI";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oabmFtV3kAd9WPDzM9z0nigNluNi0LQOuY0uH7ii+pY=";
  };

  vendorHash = "sha256-EJBkjT/JqVap/vuL4yp3Jm+6lnHnnYtwmvi8uTvrZsE=";

  meta = {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "Simple and fast anti-censorship tool written in Go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
  };
})
