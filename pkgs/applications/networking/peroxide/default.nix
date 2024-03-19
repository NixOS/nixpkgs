{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "peroxide";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ljanyst";
    repo = "peroxide";
    rev = "v${version}";
    sha256 = "sha256-6Jb1i4aNjeemiQp9FF/KGyZ+Evom9PPBvARbJWyrhok=";
  };

  vendorHash = "sha256-kuFlkkMkCKO5Rrh1EoyVdaykvxTfchK2l1/THqTBeAY=";

  postPatch = ''
    # These tests connect to the internet, which does not work in sandboxed
    # builds, so skip these.
    rm pkg/pmapi/dialer_pinning_test.go \
       pkg/pmapi/dialer_proxy_provider_test.go \
       pkg/pmapi/dialer_proxy_test.go
  '';

  passthru.tests.peroxide = nixosTests.peroxide;

  meta = with lib; {
    homepage = "https://github.com/ljanyst/peroxide";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aidalgol ];
    description = "Unofficial ProtonMail bridge";
    longDescription = ''
      Peroxide is a fork of the official ProtonMail bridge that aims to be
      similar to Hydroxide while reusing as much code from the official bridge
      as possible.
    '';
  };
}
