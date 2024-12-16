{ buildGoModule, authentik }:

buildGoModule {
  pname = "authentik-radius-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-BcL9QAc2jJqoPaQImJIFtCiu176nxmVcCLPjXjNBwqI=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/radius" ];

  meta = authentik.meta // {
    description = "Authentik radius outpost which is used for the external radius API";
    homepage = "https://goauthentik.io/docs/providers/radius/";
    mainProgram = "radius";
  };
}
