{ alephone, fetchurl }:

alephone.makeWrapper rec {
  pname = "marathon-pheonix";
  desktopName = "Marathon-Pheonix";
  version = "1.3";

  zip = fetchurl {
    url = "http://simplici7y.com/version/file/998/Marathon_Phoenix_1.3.zip";
    hash = "sha256-EicLN54di18sarKyJm2GaEJJIsvaRmlHS/TUiT6YBuQ=";
  };

  meta = {
    description = "35-level single player major Marathon conversion";
    homepage = "http://www.simplici7y.com/items/marathon-phoenix-2";
  };

}
