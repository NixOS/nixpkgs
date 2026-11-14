{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "SpoofDPI";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "xvzc";
    repo = "SpoofDPI";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F5he+n+q0jwGvA/EvcA3hr4M8++2QQDTHJb156gpTZM=";
  };

  vendorHash = "sha256-EJBkjT/JqVap/vuL4yp3Jm+6lnHnnYtwmvi8uTvrZsE=";

  meta = {
    homepage = "https://github.com/xvzc/SpoofDPI";
    description = "Simple and fast anti-censorship tool written in Go";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ s0me1newithhand7s ];
  };
})
