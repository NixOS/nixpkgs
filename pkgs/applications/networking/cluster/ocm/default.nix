{ lib, buildGoModule, fetchFromGitHub, testVersion, ocm }:

buildGoModule rec {
  pname = "ocm";
  version = "0.1.62";

  src = fetchFromGitHub {
    owner = "openshift-online";
    repo = "ocm-cli";
    rev = "v${version}";
    sha256 = "0kv0zcx6wdlyid37ygzg05xyyk77ybd2qcdgbswjv6crcjh1xdrd";
  };

  vendorSha256 = "sha256-nXUrbF9mcHy8G7c+ktQixBmmf6x066gpuaZ0eUsJQwc=";

  # Tests expect the binary to be located in the root directory.
  preCheck = ''
    ln -s $GOPATH/bin/ocm ocm
  '';

  passthru.tests.version = testVersion {
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
