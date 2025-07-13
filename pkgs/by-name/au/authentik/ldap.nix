{
  buildGoModule,
  authentik,
}:

buildGoModule {
  pname = "authentik-ldap-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-rYwtS6gypC35c4+BgxQ+oDOew+Nnpn9tB4OC8daw/FU=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/ldap" ];

  meta = authentik.meta // {
    description = "Authentik ldap outpost. Needed for the external ldap API";
    homepage = "https://goauthentik.io/docs/providers/ldap/";
    mainProgram = "ldap";
  };
}
