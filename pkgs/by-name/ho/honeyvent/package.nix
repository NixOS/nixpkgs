{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "honeyvent";
  version = "1.1.0";
  vendorHash = null;

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "honeyvent";
    rev = "v${version}";
    hash = "sha256-yFQEOshjaH6fRCQ7IZChANI9guZlTXk35p1NzQvxUdI=";
  };

  meta = with lib; {
    description = "CLI for sending individual events to honeycomb.io";
    homepage = "https://honeycomb.io/";
    license = licenses.asl20;
    maintainers = [ maintainers.iand675 ];
  };
}
