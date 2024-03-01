{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "klog-time-tracker";
  version = "6.2";

  src = fetchFromGitHub {
    owner = "jotaen";
    repo = "klog";
    rev = "v${version}";
    hash = "sha256-PFYPthrschw6XEf128L7yBygrVR3E3rtATCpxXGFRd4=";
  };

  vendorHash = "sha256-X5xL/4blWjddJsHwwfLpGjHrfia1sttmmqHjaAIVXVo=";

  meta = with lib; {
    description = "Command line tool for time tracking in a human-readable, plain-text file format";
    homepage = "https://klog.jotaen.net";
    license = licenses.mit;
    maintainers = [ maintainers.blinry ];
    mainProgram = "klog";
  };
}
