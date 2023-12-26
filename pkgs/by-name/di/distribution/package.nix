{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:

buildGoModule rec {
  pname = "distribution";
  version = "3.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "distribution";
    rev = "v${version}";
    hash = "sha256-reguAtBkEC9OMUTdCtFY6l0fkk28VoA0IlPcQ0sz84I=";
  };

  patches = [
    # fix: load gcs credentials and client inside DriverConstructor
    # Needed to pass the tests. Remove with next update.
    (fetchpatch {
      url = "https://github.com/distribution/distribution/commit/14366a2dff6a8f595e39d258085381731b43cec6.diff";
      hash = "sha256-0ns9JuIeLBzRLMVxY6uaWTIYcRRbuwQ+n9tmK+Pvf4U=";
    })
    # fix: add missing skip in s3 driver test
    # Needed to pass the tests. Remove with next update.
    (fetchpatch {
      url = "https://github.com/distribution/distribution/commit/6908e0d5facd31ed32046df03a09040c964be0b3.patch";
      hash = "sha256-ww+BwBGw+dkZ2FhVzynehR+sNYCgq8/KkPDP9ac6NWg=";
    })
  ];

  vendorHash = null;

  checkFlags = [
    # TestHTTPChecker: requires internet access.
    # TestInMemoryDriverSuite: timeout after 10 minutes, looks like a deadlock.
    "-skip=^TestHTTPChecker$|^TestInMemoryDriverSuite$"
  ];

  meta = with lib; {
    description = "Docker toolset to pack, ship, store, and deliver content";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.unix;
  };
}
