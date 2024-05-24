{ lib, buildGoModule, authentik }:

buildGoModule {
  pname = "authentik-radius-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-YpOG5pNw5CNSubm1OkPVpSi7l+l5UdJFido2SQLtK3g=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/radius" ];

  meta = authentik.meta // {
    description = "Authentik radius outpost which is used for the external radius API";
    homepage = "https://goauthentik.io/docs/providers/radius/";
    mainProgram = "radius";
  };
}
