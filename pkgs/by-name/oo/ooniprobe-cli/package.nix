{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ooniprobe-cli";
  version = "3.29.0";

  src = fetchFromGitHub {
    owner = "ooni";
    repo = "probe-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bh17+yMs7DMffoJstYbYnvwEAue34rPmKadFQQQxYxQ=";
  };

  vendorHash = "sha256-kbvdUqAz9k3AHtitoVr4q1kGMf2Jzfs6iSRUl1sp4UU=";

  subPackages = [ "cmd/ooniprobe" ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    changelog = "https://github.com/ooni/probe-cli/releases/tag/${finalAttrs.src.tag}";
    description = "Open Observatory of Network Interference command line network probe";
    homepage = "https://ooni.org/install/cli";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
    mainProgram = "ooniprobe";
  };
})
