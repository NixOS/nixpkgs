{ lib, buildGoModule, authentik }:

buildGoModule {
  pname = "authentik-ldap-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-74rSuZrO5c7mjhHh0iQlJEkOslsFrcDb1aRXXC4RsUM=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ldap" ];

  meta = authentik.meta // {
    description = "The authentik ldap outpost. Needed for the extendal ldap API.";
    homepage = "https://goauthentik.io/docs/providers/ldap/";
    mainProgram = "ldap";
  };
}
