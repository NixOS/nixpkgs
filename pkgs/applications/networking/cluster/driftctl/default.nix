{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "driftctl";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "cloudskiff";
    repo = "driftctl";
    rev = "v${version}";
    sha256 = "sha256-Qz/yObF1Df62Hqwl6fPHGkWcsifvgO5EfeiyU3aql3Q=";
  };

  vendorSha256 = "sha256-wOk4IXD9qHG8R4iddlc4TLH39jVSof9bwTDU1kyAmuA=";

  postUnpack = ''
    # Without this, tests fail to locate aws/3.19.0.json
    for prefix in /                        \
                  /pkg                     \
                  /pkg/analyser            \
                  /pkg/alerter             \
                  /pkg/remote              \
                  /pkg/middlewares         \
                  /pkg/cmd/scan/output     \
                  /pkg/iac/terraform/state \
                  /pkg/iac/supplier ; do
      mkdir -p ./source/$prefix/github.com/cloudskiff
      ln -sf $PWD/source ./source/$prefix/github.com/cloudskiff/driftctl
    done

    # Disable check for latest version and telemetry, which are opt-out.
    # Making it out-in is quite a job, and why bother?
    find -name '*.go' \
      | xargs sed -i 's,https://2lvzgmrf2e.execute-api.eu-west-3.amazonaws.com/,https://0.0.0.0/,g'

    # and remove corresponding flags from --help, so things look tidy.
    find -name driftctl.go | \
      xargs sed -i -e '/("no-version-check"/ d'  -e '/("disable-telemetry"/ d'

    # Presumably it can be done with ldflags, but I failed to find incantation
    # that would work, we here we go old-school.
    find -name version.go | xargs sed -i -e 's/"dev"/"${version}"/'
    find -name build.go | xargs sed -i -e 's/"dev"/"release"/'

    # Fix the tests that checks for dev-dev.
    find -name version_test.go | xargs sed -i -e 's/"dev-dev/"${version}/'
    find -name driftctl_test.go | xargs sed -i -e 's/"dev-dev/"${version}/'
  '';

  meta = with lib; {
    description = "Tool to track infrastructure drift";
    homepage = "https://github.com/cloudskiff/driftctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ kaction ];
  };
}
