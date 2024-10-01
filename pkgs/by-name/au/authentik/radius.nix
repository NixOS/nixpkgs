{
  buildGo123Module,
  authentik,
}:

buildGo123Module {
  pname = "authentik-radius-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-xaVEyG5fNGh/zmXkewve5V2q2W7u+hqo27GqabAV9H0=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/radius" ];

  meta = authentik.meta // {
    description = "Authentik radius outpost which is used for the external radius API";
    homepage = "https://goauthentik.io/docs/providers/radius/";
    mainProgram = "radius";
  };
}
