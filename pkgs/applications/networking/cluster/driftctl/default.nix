{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "driftctl";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "cloudskiff";
    repo = "driftctl";
    rev = "v${version}";
    sha256 = "sha256:1k9mx3yh5qza5rikg38ls78gbi4mw8ar4c1x9ij863w1c28fdzlb";
  };

  vendorSha256 = "sha256:0dajz1xbf607l9y5kby4kh7h28v4b3jjmnjsf6cys46pcgxa0zw3";

  postUnpack = ''

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
  '';

  meta = with lib; {
    description = "Tool to track infrastructure drift";
    homepage = "https://github.com/cloudskiff/driftctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ kaction ];
  };
}
