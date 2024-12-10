{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "klog-time-tracker";
  version = "6.5";

  src = fetchFromGitHub {
    owner = "jotaen";
    repo = "klog";
    rev = "v${version}";
    hash = "sha256-xwVbI4rXtcZrnTvp0vdHMbYRoWCsxIuGZF922eC/sfw=";
  };

  vendorHash = "sha256-QOS+D/zD5IlJBlb7vrOoHpP/7xS9En1/MFNwLSBrXOg=";

  meta = with lib; {
    description = "Command line tool for time tracking in a human-readable, plain-text file format";
    homepage = "https://klog.jotaen.net";
    license = licenses.mit;
    maintainers = [ maintainers.blinry ];
    mainProgram = "klog";
  };
}
