{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "klog-time-tracker";
  version = "6.3";

  src = fetchFromGitHub {
    owner = "jotaen";
    repo = "klog";
    rev = "v${version}";
    hash = "sha256-/NbMXJY853XIiEEVPJdZRO5IZEDYaalSekQ4kxnZgIw=";
  };

  vendorHash = "sha256-L84eKm1wktClye01JeyF0LOV9A8ip6Fr+/h09VVZ56k=";

  meta = with lib; {
    description = "Command line tool for time tracking in a human-readable, plain-text file format";
    homepage = "https://klog.jotaen.net";
    license = licenses.mit;
    maintainers = [ maintainers.blinry ];
    mainProgram = "klog";
  };
}
