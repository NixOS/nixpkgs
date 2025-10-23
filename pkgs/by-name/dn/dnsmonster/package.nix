{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "dnsmonster";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "mosajjal";
    repo = "dnsmonster";
    tag = "v${version}";
    hash = "sha256-sg+88WbjlfcPgWQ9RnmLr6/VWwXEjsctfWt4TGx1oNc=";
  };

  vendorHash = "sha256-PIiSpxfZmhxWkHUnoDYKppI7/gzGm0RKh7u9HK4zrEU=";

  buildInputs = [ libpcap ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/mosajjal/dnsmonster/util.releaseVersion=${version}"
  ];

  meta = {
    description = "Passive DNS Capture and Monitoring Toolkit";
    homepage = "https://github.com/mosajjal/dnsmonster";
    changelog = "https://github.com/mosajjal/dnsmonster/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "dnsmonster";
  };
}
