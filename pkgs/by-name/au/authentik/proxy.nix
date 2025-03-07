{
  buildGoModule,
  authentik,
}:

buildGoModule {
  pname = "authentik-proxy-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-aG/VqpmHJeGyF98aS0jgwEAq1R5c8VggeJxLWS9W8HY=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/proxy" ];

  meta = authentik.meta // {
    description = "Authentik proxy outpost which is used for HTTP reverse proxy authentication";
    homepage = "https://goauthentik.io/docs/providers/proxy/";
    mainProgram = "proxy";
  };
}
