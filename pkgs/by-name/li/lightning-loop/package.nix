{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "lightning-loop";
  version = "0.31.4-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "loop";
    rev = "v${version}";
    hash = "sha256-kcPN4P7lsML2qwvuopgX+HyYwrpL9xwZAPA7gHqAPms=";
  };

  vendorHash = "sha256-6VWtxiNLTH0hHdA4sqHWrwX0x9NH6QYJCZ9LuXUgsA4=";

  subPackages = [
    "cmd/loop"
    "cmd/loopd"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Lightning Loop Client";
    homepage = "https://github.com/lightninglabs/loop";
    license = licenses.mit;
    maintainers = with maintainers; [ proofofkeags ];
  };
}
