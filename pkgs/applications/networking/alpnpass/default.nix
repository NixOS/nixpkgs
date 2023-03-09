{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "alpnpass";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "VerSprite";
    repo = "alpnpass";
    rev = version;
    hash = "sha256-hNZqGTV17rFSKLhZzNqH2E4SSb6Jhk7YQ4TN0HnE+9g=";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Inspect the plaintext payload inside of proxied TLS connections";
    longDescription = ''
      This tool will listen on a given port, strip SSL encryption,
      forward traffic through a plain TCP proxy,
      then encrypt the returning traffic again
      and send it to the target of your choice.

      Unlike most SSL stripping solutions this tool will negotiate ALPN and
      preserve the negotiated protocol all the way to the target.
    '';
    homepage = "https://github.com/VerSprite/alpnpass";
    license = licenses.unlicense;
    maintainers = [ maintainers.raboof ];
  };
}
