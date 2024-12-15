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
    rev = "v1.0.0";
    hash = "sha256-tne+vabRlVIpASvqioUBm/ANsWszy1MQ7bkFr1joMrg=";
  };
  vendorHash = "sha256-pyNBOPzzJ+ZcIlGP0DP+MEbQt52XyqJJ/bo+OsmPwUk=";
  meta = {
    description = "A command-line utility for creating forms and sending notifications";
    longDescription = ''
      This tool enables users to create customizable forms and send notifications directly from the command line. It's useful for automating repetitive tasks and handling user inputs easily.
    '';
    homepage = "https://github.com/NewDawn0/notify";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ NewDawn0 ];
    platforms = lib.platforms.all;
  };
}
