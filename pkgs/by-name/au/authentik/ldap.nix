{
  buildGoModule,
  authentik,
}:

buildGoModule {
  pname = "authentik-ldap-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-FyRTPs2xfostV2x03IjrxEYBSrsZwnuPn+oHyQq1Kq0=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/ldap" ];

  meta = authentik.meta // {
    description = "The authentik ldap outpost. Needed for the external ldap API.";
    homepage = "https://goauthentik.io/docs/providers/ldap/";
    mainProgram = "ldap";
  };
}
