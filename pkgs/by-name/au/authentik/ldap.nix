{
  buildGoModule,
  authentik,
}:

buildGoModule {
  pname = "authentik-ldap-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-cEB22KFDONcJBq/FvLpYKN7Zd06mh8SACvCSuj5i4fI=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/ldap" ];

  meta = authentik.meta // {
    description = "The authentik ldap outpost. Needed for the external ldap API.";
    homepage = "https://goauthentik.io/docs/providers/ldap/";
    mainProgram = "ldap";
  };
}
