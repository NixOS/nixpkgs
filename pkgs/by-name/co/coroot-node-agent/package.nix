{
  lib,
  buildGoModule,
  fetchFromGitHub,
  systemdLibs,
}:

buildGoModule rec {
  pname = "coroot-node-agent";
  version = "1.27.2";

  src = fetchFromGitHub {
    owner = "coroot";
    repo = "coroot-node-agent";
    rev = "v${version}";
    hash = "sha256-bA23qnC94hrmyQWR5kAKR27wzs55AJPC3Ix/l/9YCEY=";
  };

  vendorHash = "sha256-jMR/ylMEgNDOn5mDkJU38h9h2rinCX7/jtOyjDos5Qc=";

  buildInputs = [ systemdLibs ];

  CGO_CFLAGS = "-I ${systemdLibs}/include";

  ldflags = [
    "-extldflags='-Wl,-z,lazy'"
    "-X 'github.com/coroot/coroot-node-agent/flags.Version=${version}'"
  ];

  meta = {
    description = "Prometheus exporter based on eBPF";
    homepage = "https://github.com/coroot/coroot-node-agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ errnoh ];
    mainProgram = "coroot-node-agent";
  };
}
