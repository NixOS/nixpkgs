{ lib, go, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "qbec";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "splunk";
    repo = "qbec";
    rev = "v${version}";
    sha256 = "sha256-F5xnW9069Xrl6isvmeYtfTZUZSiSq47HLs5/p3HCf6E=";
  };

  vendorSha256 = "sha256-wtpXqIixjRYYSIPe43Q5627g6mu05WdvwCi9cXVgCBs=";

  doCheck = false;

  buildFlagsArray = ''
    -ldflags=
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=${version}
      -X github.com/splunk/qbec/internal/commands.commit=${src.rev}
      -X github.com/splunk/qbec/internal/commands.goVersion=${lib.getVersion go}
  '';

  meta = with lib; {
    description = "Configure kubernetes objects on multiple clusters using jsonnet https://qbec.io";
    homepage = "https://github.com/splunk/qbec";
    license = licenses.asl20;
    maintainers = with maintainers; [ groodt ];
  };
}
