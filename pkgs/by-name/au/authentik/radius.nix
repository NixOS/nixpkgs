{
  buildGoModule,
  authentik,
}:

buildGoModule {
  pname = "authentik-radius-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-cEB22KFDONcJBq/FvLpYKN7Zd06mh8SACvCSuj5i4fI=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/radius" ];

  meta = authentik.meta // {
    description = "Authentik radius outpost which is used for the external radius API";
    homepage = "https://goauthentik.io/docs/providers/radius/";
    mainProgram = "radius";
  };
}
