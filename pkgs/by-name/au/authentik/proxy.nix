{
  buildGo123Module,
  authentik,
}:

buildGo123Module {
  pname = "authentik-proxy-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-xaVEyG5fNGh/zmXkewve5V2q2W7u+hqo27GqabAV9H0=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/proxy" ];

  meta = authentik.meta // {
    description = "Authentik proxy outpost which is used for HTTP reverse proxy authentication";
    homepage = "https://goauthentik.io/docs/providers/proxy/";
    mainProgram = "proxy";
  };
}
