{ lib, mkFranzDerivation, fetchurl }:

mkFranzDerivation rec {
  pname = "franz";
  name = "Franz";
  version = "5.6.1";
  src = fetchurl {
    url = "https://github.com/meetfranz/franz/releases/download/v${version}/franz_${version}_amd64.deb";
    sha256 = "1gn0n1hr6z2gsdnpxysyq6sm8y7cjr9jafhsam8ffw0bq74kph7p";
  };
  meta = with lib; {
    description = "A free messaging app that combines chat & messaging services into one application";
    homepage = "https://meetfranz.com";
    license = licenses.free;
    maintainers = [ maintainers.davidtwco ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
  };
}
