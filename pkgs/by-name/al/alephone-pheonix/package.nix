{ alephone, fetchurl }:

alephone.makeWrapper {
  pname = "marathon-pheonix";
  desktopName = "Marathon-Pheonix";
  version = "1.4.2.3";

  # upstream only offers it on ModDB, which can't be fetched without a browser
  zip = fetchurl {
    urls = [
      "https://slackware.uk/~urchlay/src/Marathon_Phoenix_1.4.2.3.zip"
      "https://web.archive.org/web/20260422175653id_/https://slackware.uk/~urchlay/src/Marathon_Phoenix_1.4.2.3.zip"
    ];
    hash = "sha256-LhTaCWUzJ5YHnUxC9drTOOuyQx+BS0XdKmLhTMlAMUE=";
  };

  meta = {
    description = "35-level single player major Marathon conversion";
    homepage = "http://www.simplici7y.com/items/marathon-phoenix-2";
  };

}
