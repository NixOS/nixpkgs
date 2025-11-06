{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "autospotting";
  version = "0-unstable-2023-07-03";

  src = fetchFromGitHub {
    owner = "LeanerCloud";
    repo = "AutoSpotting";
    rev = "6b08f61d72eafddf01bb68ccb789505f1c7be3eb";
    hash = "sha256-gW8AIPqwNXfjsPxPv/5+gF374wTw8iavhjmlG4Onkxg=";
  };

  vendorHash = "sha256-RuBchKainwE6RM3AphKWjndGZc1nh7A/Xxcacq1r7Nk=";

  excludedPackages = [ "scripts" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Automatically convert your existing AutoScaling groups to up to 90% cheaper spot instances with minimal configuration changes";
    homepage = "https://github.com/cloudutil/AutoSpotting";
    license = licenses.osl3;
    maintainers = with maintainers; [ costrouc ];
    mainProgram = "AutoSpotting";
  };
}
