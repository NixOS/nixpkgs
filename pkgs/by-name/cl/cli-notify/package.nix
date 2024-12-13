{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule {
  pname = "notify";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "notify";
    rev = "b40a50df9464602b21b25c48a99197af842270f3";
    hash = "sha256-PnNrb5qd8qJlR3pRkgf3pgG66KqlzBjzXg1LyfKbav4=";
  };
  vendorHash = "sha256-pyNBOPzzJ+ZcIlGP0DP+MEbQt52XyqJJ/bo+OsmPwUk=";

  meta = with lib; {
    description = "Create forms and send notifications from the CLI";
    homepage = "https://github.com/NewDawn0/notify";
    maintainers = with maintainers; [NewDawn0];
    license = licenses.mit;
  };
}
