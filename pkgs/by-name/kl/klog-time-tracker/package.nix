{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "klog-time-tracker";
  version = "7.2";

  src = fetchFromGitHub {
    owner = "jotaen";
    repo = "klog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qRbANEJLmJplus0Pr7SGQY7cRVxHL5p3B89b0n9LoWE=";
  };

  vendorHash = "sha256-NLlFBupa7Uy2sjIu/RZ3By2IxnekSRIMjJvGBFJB3Xs=";

  meta = {
    description = "Command line tool for time tracking in a human-readable, plain-text file format";
    homepage = "https://klog.jotaen.net";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.blinry ];
    mainProgram = "klog";
  };
})
