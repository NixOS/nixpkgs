{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "desync";
  version = "0.9.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "folbricht";
    repo = "desync";
    sha256 = "sha256-yGlf6Z38GnOWSc2pvt/u4arx5lCB0QpoqPdNamdL9b0=";
  };

  vendorSha256 = "sha256-c+Sz3WMKyzdEE/Hs+7dekQPn+62ddbmfvV21W0KeLDU=";

  # nix builder doesn't have access to test data; tests fail for reasons unrelated to binary being bad.
  doCheck = false;

  meta = with lib; {
    description = "Content-addressed binary distribution system";
    longDescription = "An alternate implementation of the casync protocol and storage mechanism with a focus on production-readiness";
    homepage = "https://github.com/folbricht/desync";
    license = licenses.bsd3;
    platforms = platforms.unix; # *may* work on Windows, but varies between releases.
    maintainers = [ maintainers.chaduffy ];
  };
}
