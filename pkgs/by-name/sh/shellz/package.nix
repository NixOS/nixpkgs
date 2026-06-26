{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "shellz";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "shellz";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sUYDopSxaUPyrHev8XXobRoX6uxbdf5goJ75KYEPFNY=";
  };

  vendorHash = "sha256-9uQMimttsNCA//DgDMuukXUROlIz3bJfr04XfVpPLZM=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Utility to manage your SSH, telnet, kubernetes, winrm, web or any custom shell";
    homepage = "https://github.com/evilsocket/shellz";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "shellz";
  };
})
