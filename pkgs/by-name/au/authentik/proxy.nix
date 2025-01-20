{
  buildGoModule,
  authentik,
}:

buildGoModule {
  pname = "authentik-proxy-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-FyRTPs2xfostV2x03IjrxEYBSrsZwnuPn+oHyQq1Kq0=";

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/proxy" ];

  meta = authentik.meta // {
    description = "Authentik proxy outpost which is used for HTTP reverse proxy authentication";
    homepage = "https://goauthentik.io/docs/providers/proxy/";
    mainProgram = "proxy";
  };
}
