{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "desync";
  version = "0.9.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "folbricht";
    repo = "desync";
    sha256 = "0j9hixgkja268r2zn2dglrmlrb2z57sgz6q3wqb8dfwpan7b5rsy";
  };

  vendorSha256 = "1gajh99jb6mbwk93dypddhl7r7n8h2s11s3s82firbrb5k24s4pz";

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
