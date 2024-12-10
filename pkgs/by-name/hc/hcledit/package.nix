{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "hcledit";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "minamijoyo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EJSV7CsxnRCsVcqsJcImqeELdeg6Mnf7N6S9TlMbTaE=";
  };

  vendorHash = "sha256-G6jmdosQHBA+n7MgVAlzdSTqPYb5d+k4b4EzAI384FQ=";

  meta = with lib; {
    description = "Command line editor for HCL";
    mainProgram = "hcledit";
    homepage = "https://github.com/minamijoyo/hcledit";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
