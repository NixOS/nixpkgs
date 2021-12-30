{ lib
, buildGoPackage
, fetchFromGitHub
, ircdog
, testVersion
}:

buildGoPackage rec {
  pname = "ircdog";
  version = "0.2.1";

  goPackagePath = "github.com/goshuirc/ircdog";

  src = fetchFromGitHub {
    owner = "goshuirc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ppbznlkv7vajfbimxbyiq5y6pkfhm6ylhl408rwq1bawl28hpkl";
    fetchSubmodules = true;
  };

  passthru.tests.version = testVersion { package = ircdog; };

  meta = with lib; {
    description = "ircdog is a simple wrapper over the raw IRC protocol that can respond to pings, and interprets formatting codes";
    homepage = "https://github.com/goshuirc/ircdog";
    license = licenses.isc;
    maintainers = with maintainers; [ hexa ];
  };
}


