{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "klog-time-tracker";
  version = "7.0";

  src = fetchFromGitHub {
    owner = "jotaen";
    repo = "klog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lr9MLEodp+lZSXvRRGnEC74ws3pyxVWxjKgguy3ydZ8=";
  };

  vendorHash = "sha256-zaQzDmF9m7pHpOzYxcrQ8loIclM2bWv5W3/9icgvUEY=";

  meta = {
    description = "Command line tool for time tracking in a human-readable, plain-text file format";
    homepage = "https://klog.jotaen.net";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.blinry ];
    mainProgram = "klog";
  };
})
