{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gmailctl";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    sha256 = "sha256-UZzpecW4vW1JYUDCcwDIJXCGjw80fgZC4wvCh0DdE98=";
  };

  vendorSha256 = "sha256-5oVr1qazTzsSNVLvcAsAN8UyrJOeqLjSVinImLOyJlk=";

  doCheck = false;

  meta = with lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.unix;
  };
}
