{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "go-test-html-report";
  version = "0.1.3";
  commit = "7da29ba48cc98393e14968fab1ccfd3f5e9da30e";

  src = fetchFromGitHub {
    owner = "brpaz";
    repo = pname;
    rev = "${version}";
    hash = "sha256-qPsXYTyoiKV7CondIPUERKmAnPtfZRlxVJ6E5I+ms1I=";
  };
  vendorHash = "sha256-KkTloTW0IhdULyOm3OB+LHKa7phYGJa1Pmf6nfmAsd0=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${commit}"
  ];

  env.CGO_ENABLED = 0;

  subPackages = [ "cmd/go-test-html-report" ];

  meta = with lib; {
    description = "Generate HTML test reports from 'go test -json' output";
    homepage = "https://github.com/brpaz/go-test-html-report";
    license = licenses.mit;
    maintainers = with maintainers; [ brpaz ];
    mainProgram = "go-test-html-report";
  };
}
