{
  buildGo123Module,
  authentik,
}:

buildGo123Module {
  pname = "authentik-ldap-outpost";
  inherit (authentik) version src;

  vendorHash = "sha256-xaVEyG5fNGh/zmXkewve5V2q2W7u+hqo27GqabAV9H0=";

  CGO_ENABLED = 0;

  subPackages = [ "cmd/ldap" ];

  meta = authentik.meta // {
    description = "The authentik ldap outpost. Needed for the external ldap API.";
    homepage = "https://goauthentik.io/docs/providers/ldap/";
    mainProgram = "ldap";
  };
}
