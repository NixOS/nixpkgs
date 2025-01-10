{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "marathon-pheonix";
  desktopName = "Marathon-Pheonix";
  version = "1.3";

  zip = fetchurl {
    url = "http://simplici7y.com/version/file/998/Marathon_Phoenix_1.3.zip";
    sha256 = "1r06k0z8km7l9d3njinsrci4jhk8hrnjdcmjd8n5z2qxkqvhn9qj";
  };

  meta = {
    description = "35-level single player major Marathon conversion";
    homepage = "http://www.simplici7y.com/items/marathon-phoenix-2";
  };

}
