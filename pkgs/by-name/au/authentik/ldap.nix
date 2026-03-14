{
  buildGoModule,
  authentik,
  apiGoVendorHook,
  proxy,
}:

buildGoModule {
  pname = "authentik-ldap-outpost";
  inherit (authentik) version src;
  inherit (proxy) vendorHash;

  nativeBuildInputs = [ apiGoVendorHook ];

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/ldap" ];

  meta = authentik.meta // {
    description = "Authentik ldap outpost. Needed for the external ldap API";
    homepage = "https://goauthentik.io/docs/providers/ldap/";
    mainProgram = "ldap";
  };
}
