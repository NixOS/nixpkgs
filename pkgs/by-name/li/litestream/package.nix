{
  buildGoModule,
  fetchFromGitHub,
  iana-etc,
  lib,
  nixosTests,
}:
buildGoModule rec {
  pname = "litestream";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = "litestream";
    rev = "v${version}";
    sha256 = "sha256-u0l95Hkhbga6WLKhxlv+Ce/ImCUkvuOj/zdo9KAMjeE=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  vendorHash = "sha256-fVF07uFlntGxNAVJUfwMAYw6Ju5R7ATABdMT++VmqF4=";

  passthru.tests = { inherit (nixosTests) litestream; };

  # The transitive dependency modernc.org/libc attempts reading /etc/protocols
  # in a unit test. If the read fails, then the test fails.
  nativeBuildInputs = [ iana-etc ];

  meta = with lib; {
    description = "Streaming replication for SQLite";
    mainProgram = "litestream";
    license = licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = with maintainers; [ fbrs ];
  };
}
