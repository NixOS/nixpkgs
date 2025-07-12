{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "klog-time-tracker";
  version = "6.6";

  src = fetchFromGitHub {
    owner = "jotaen";
    repo = "klog";
    rev = "v${version}";
    hash = "sha256-Tq780+Gsu2Ym9+DeMpaOhsP2XluyKBh01USnmwlYsTs=";
  };

  vendorHash = "sha256-ilV/+Xogy4+5c/Rs0cCSvVTgDhL4mm9V/pxJB3XGDkw=";

  meta = with lib; {
    description = "Command line tool for time tracking in a human-readable, plain-text file format";
    homepage = "https://klog.jotaen.net";
    license = licenses.mit;
    maintainers = [ maintainers.blinry ];
    mainProgram = "klog";
  };
}
