{ lib, buildGoModule, fetchFromGitHub, stdenv, testers, ocm }:

buildGoModule rec {
  pname = "ocm";
  version = "0.1.63";

  src = fetchFromGitHub {
    owner = "openshift-online";
    repo = "ocm-cli";
    rev = "v${version}";
    sha256 = "sha256-wBKW2WS1+JmWOFCArmrlVfUTEqFYF7aq1OBrUo7e4ac=";
  };

  vendorSha256 = "sha256-LyQ/F+E0y1gQtpGSyPEB2z2ImorA7mjY3QjrRORakIo=";

  # Strip the final binary.
  ldflags = [ "-s" "-w" ];

  # Tests expect the binary to be located in the root directory.
  preCheck = ''
    ln -s $GOPATH/bin/ocm ocm
  '';

  # Tests fail in Darwin sandbox.
  doCheck = !stdenv.isDarwin;

  passthru.tests.version = testers.testVersion {
    package = ocm;
    command = "ocm version";
  };

  meta = with lib; {
    description = "CLI for the Red Hat OpenShift Cluster Manager";
    license = licenses.asl20;
    homepage = "https://github.com/openshift-online/ocm-cli";
    maintainers = with maintainers; [ stehessel ];
  };
}
