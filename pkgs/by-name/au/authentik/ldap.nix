{ lib, buildGoModule, authentik }:

buildGoModule {
  pname = "authentik-ldap-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-UIJBCTq7AJGUDIlZtJaWCovyxlMPzj2BCJQqthybEz4=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ldap" ];

  meta = authentik.meta // {
    description = "Authentik ldap outpost. Needed for the extendal ldap API";
    homepage = "https://goauthentik.io/docs/providers/ldap/";
    mainProgram = "ldap";
  };
}
