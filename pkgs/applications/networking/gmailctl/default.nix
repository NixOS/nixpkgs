{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gmailctl";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    sha256 = "sha256-1gOixuOvPHEjnnDNNda9sktnhffovOfeG4XDrLRRMlE=";
  };

  vendorSha256 = "sha256-Yv3OGHFOmenst/ujUgvCaSEjwwBf3W9n+55ztVhuWjo=";

  doCheck = false;

  meta = with lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.unix;
  };
}
