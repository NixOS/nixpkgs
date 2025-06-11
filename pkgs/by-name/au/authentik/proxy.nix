{
  buildGoModule,
  authentik,
}:

buildGoModule {
  pname = "authentik-proxy-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-cEB22KFDONcJBq/FvLpYKN7Zd06mh8SACvCSuj5i4fI=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/proxy" ];

  meta = authentik.meta // {
    description = "Authentik proxy outpost which is used for HTTP reverse proxy authentication";
    homepage = "https://goauthentik.io/docs/providers/proxy/";
    mainProgram = "proxy";
  };
}
