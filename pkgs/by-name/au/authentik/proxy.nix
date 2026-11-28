{
  buildGo127Module,
  authentik,
  apiGoVendorHook,
  vendorHash,
}:

buildGo127Module {
  pname = "authentik-proxy-outpost";
  inherit (authentik) version src;
  inherit vendorHash;

  nativeBuildInputs = [ apiGoVendorHook ];

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/proxy" ];

  meta = authentik.meta // {
    description = "Authentik proxy outpost which is used for HTTP reverse proxy authentication";
    homepage = "https://goauthentik.io/docs/providers/proxy/";
    mainProgram = "proxy";
  };
}
